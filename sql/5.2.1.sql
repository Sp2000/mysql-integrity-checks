(SELECT 'Integrity check',
       'Editorial decision                                     ',
       'SynID',
       'ParentID',
       'Genus',
       'SubGenusName',
       'SpeciesEpithet',
       'AuthorString',
       'GSDNameStatus',
       'Sp2000Status')
UNION ALL
    SELECT '5.2.1 GSD duplicates SYN-SYN species (different parent, same authors)',
            '',
            GM_SYN_ID              AS SynID,
            GM_SYN_AcceptedTaxonID AS ParentID,
            GM_SYN_Genus,
            GM_SYN_SubGenusName,
            GM_SYN_SpeciesEpithet,
            GM_SYN_AuthorString,
            GM_SYN_GSDNameStatus,
            GM_SYN_Sp2000NameStatus
     FROM GM_GSD.GM_Synonyms syn
            INNER JOIN (SELECT concat_ws("_", tb1.GM_SYN_Genus, tb1.GM_SYN_SubGenusName, tb1.GM_SYN_SpeciesEpithet,
                                         tb1.GM_SYN_AuthorString) AS DupString
                        FROM GM_GSD.GM_Synonyms tb1
                               INNER JOIN GM_GSD.GM_Synonyms tb2 ON tb1.GM_SYN_Genus = tb2.GM_SYN_Genus AND
                                                                    tb1.GM_SYN_SpeciesEpithet = tb2.GM_SYN_SpeciesEpithet
                        WHERE (tb1.GM_SYN_InfraSpecies IS NULL OR tb1.GM_SYN_InfraSpecies = '')
                          AND (tb2.GM_SYN_InfraSpecies IS NULL OR tb2.GM_SYN_InfraSpecies = '')
                          AND tb1.GM_SYN_AcceptedTaxonID <> tb2.GM_SYN_AcceptedTaxonID
                          AND (((tb1.GM_SYN_SubGenusName IS NULL OR tb1.GM_SYN_SubGenusName = '')
                                  AND (tb2.GM_SYN_SubGenusName IS NULL OR tb2.GM_SYN_SubGenusName = ''))
                                 OR tb1.GM_SYN_SubGenusName = tb2.GM_SYN_SubGenusName)
                          AND tb1.GM_SYN_AuthorString = tb2.GM_SYN_AuthorString
                        GROUP BY tb1.GM_SYN_Genus, tb1.GM_SYN_SpeciesEpithet
                        HAVING count(*) > 1) dups ON dups.DupString =
                                                     concat_ws("_", syn.GM_SYN_Genus, syn.GM_SYN_SubGenusName,
                                                               syn.GM_SYN_SpeciesEpithet, syn.GM_SYN_AuthorString)
     WHERE GM_SYN_InfraSpecies IS NULL
        OR GM_SYN_InfraSpecies = ''
     ORDER BY GM_SYN_Genus, GM_SYN_SpeciesEpithet, GM_SYN_SubGenusName, GM_SYN_AuthorString;
