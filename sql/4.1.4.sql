SELECT
  'Integrity check',
  'Editorial decision                                     ',
  'gsd.AcceptedTaxonID',
  'col.record_id',
  'col.database_id',
  'col.sp2000_status_id',
  'col.is_accepted_name',
  'col.kingdom',
  'col.phylum',
  'col.class',
  'col.order',
  'gsd.Order',
  'col.family',
  'gsd.Family',
  'col.genus',
  'gsd.Genus',
  'col.subgenus',
  'gsd.SubGenusName',
  'col.species',
  'gsd.Species',
  'col.author',
  'gsd.AuthorString'
UNION SELECT
        '4.1.4 Identical accepted species name in order - superfamily - family - genus: ',
        '',
        gsd.GM_ACC_AcceptedTaxonID,
        col.record_id,
        col.database_id,
        col.sp2000_status_id,
        col.is_accepted_name,
        col.kingdom,
        col.phylum,
        col.class,
        col.`order`,
        gsd.`GM_ACC_Order`,
        col.family,
        gsd.GM_ACC_Family,
        col.genus,
        gsd.GM_ACC_Genus,
        col.subgenus,
        gsd.GM_ACC_SubGenusName,
        col.species,
        gsd.GM_ACC_SpeciesEpithet,
        col.author,
        gsd.GM_ACC_AuthorString
      FROM (SELECT
              sn.record_id,
              sn.family_code,
              fam.kingdom,
              fam.phylum,
              fam.class,
              fam.`order`,
              fam.superfamily,
              fam.family,
              sn.database_id,
              sn.genus,
              sn.subgenus,
              sn.species,
              sn.infraspecies,
              sn.author,
              sn.sp2000_status_id,
              sn.is_accepted_name
            FROM Assembly_Global.scientific_names AS sn LEFT JOIN Assembly_Global.families AS fam
                ON sn.family_code = fam.family_code) AS col INNER JOIN (SELECT
                                                                          gsd_sn.GM_ACC_AcceptedTaxonID,
                                                                          gsd_sn.`GM_ACC_Order`,
                                                                          gsd_sn.GM_ACC_SuperFamily,
                                                                          gsd_sn.GM_ACC_Family,
                                                                          gsd_sn.GM_ACC_Genus,
                                                                          gsd_sn.GM_ACC_SubGenusName,
                                                                          gsd_sn.GM_ACC_SpeciesEpithet,
                                                                          gsd_sn.GM_ACC_AuthorString
                                                                        FROM
                                                                          `GM_GSD`.`GM_AcceptedSpecies` AS gsd_sn) AS gsd
          ON col.genus = gsd.GM_ACC_Genus AND col.species = gsd.GM_ACC_SpeciesEpithet
      WHERE
        col.database_id <> '{{DatabaseID}}' AND col.`order` = gsd.`GM_ACC_Order` AND col.superfamily = gsd.GM_ACC_SuperFamily AND
        col.family = gsd.GM_ACC_Family AND col.`genus` = gsd.`GM_ACC_Genus`;
