SELECT
  'Integrity check',
  'Editorial decision                                     ',
  'AcceptedTaxonID',
  'Family',
  'Genus',
  'SubGenusName',
  'Species',
  'AuthorString'
UNION SELECT
        '2.0.0 Missing ID',
        '',
        `GM_ACC_AcceptedTaxonID`,
        `GM_ACC_Family`,
        `GM_ACC_Genus`,
        `GM_ACC_SubGenusName`,
        `GM_ACC_SpeciesEpithet`,
        `GM_ACC_AuthorString`
      FROM `GM_GSD`.`GM_AcceptedSpecies`
      WHERE `GM_ACC_AcceptedTaxonID` IS NULL OR `GM_ACC_AcceptedTaxonID` = '';
