INSERT INTO "public"."geonames" ("id", "name", "ascii_name", "latitude", "longitude", "feature_class", "feature_code", "country", "cc2", "admin1_code", "admin2_code", "admin3_code", "admin4_code", "population", "elevation", "gtopo30", "timezone", "moddate", "search_vector", "first_level_division_id", "second_level_division_id") VALUES
('6058560', 'London', 'London', '42.98339', '-81.23304', 'P', 'PPL', 'CA', NULL, '08', NULL, NULL, NULL, '346765', NULL, '252', 'America/Toronto', '2012-08-19', 'London  Ontario CA', 'CA.08', 'CA.08.'),
('5323371', 'Alondra Park', 'Alondra Park', '33.88946', '-118.33091', 'P', 'PPL', 'US', NULL, 'CA', '037', NULL, NULL, '8592', '16', '21', 'America/Los_Angeles', '2011-05-14', 'Alondra Park Los Angeles County California US', 'US.CA', 'US.CA.037'),
('4839416', 'New London', 'New London', '41.35565', '-72.09952', 'P', 'PPL', 'US', NULL, 'CT', '011', NULL, NULL, '27620', '17', '25', 'America/New_York', '2012-08-19', 'New London New London County Connecticut US', 'US.CT', 'US.CT.011'),
('4298960', 'London', 'London', '37.12898', '-84.08326', 'P', 'PPLA2', 'US', NULL, 'KY', '125', NULL, NULL, '7993', '378', '379', 'America/New_York', '2011-05-14', 'London Laurel County Kentucky US', 'US.KY', 'US.KY.125'),
('4361094', 'Londontowne', 'Londontowne', '38.93345', '-76.54941', 'P', 'PPL', 'US', NULL, 'MD', '003', NULL, NULL, '8018', '6', '6', 'America/New_York', '2010-02-15', 'Londontowne Anne Arundel County Maryland US', 'US.MD', 'US.MD.003'),
('5088905', 'Londonderry', 'Londonderry', '42.86509', '-71.37395', 'P', 'PPL', 'US', NULL, 'NH', '015', NULL, NULL, '11037', '128', '128', 'America/New_York', '2011-05-14', 'Londonderry Rockingham County New Hampshire US', 'US.NH', 'US.NH.015'),
('4517009', 'London', 'London', '39.88645', '-83.44825', 'P', 'PPLA2', 'US', NULL, 'OH', '097', NULL, NULL, '9904', '321', '321', 'America/New_York', '2011-05-14', 'London Madison County Ohio US', 'US.OH', 'US.OH.097'),
('5264455', 'New London', 'New London', '44.39276', '-88.73983', 'P', 'PPL', 'US', NULL, 'WI', '135', NULL, NULL, '7295', '234', '235', 'America/Chicago', '2011-05-14', 'New London Waupaca County Wisconsin US', 'US.WI', 'US.WI.135');

INSERT INTO "public"."geonames" ("id", "name", "ascii_name", "latitude", "longitude", "feature_class", "feature_code", "country", "cc2", "admin1_code", "admin2_code", "admin3_code", "admin4_code", "population", "elevation", "gtopo30", "timezone", "moddate", "search_vector", "first_level_division_id", "second_level_division_id") VALUES
('4954477', 'Ware', 'Ware', '42.25981', '-72.2398', 'P', 'PPL', 'US', NULL, 'MA', '015', NULL, NULL, '6170', '129', '132', 'America/New_York', '2011-05-14', 'Ware Hampshire County Massachusetts US', 'US.MA', 'US.MA.015'),
('4992940', 'Flat Rock', 'Flat Rock', '42.09643', '-83.29187', 'P', 'PPL', 'US', NULL, 'MI', '163', NULL, NULL, '9878', '183', '182', 'America/Detroit', '2011-05-14', 'Flat Rock Wayne County Michigan US', 'US.MI', 'US.MI.163'),
('4394084', 'Ladue', 'Ladue', '38.64977', '-90.38067', 'P', 'PPL', 'US', NULL, 'MO', '189', NULL, NULL, '8521', '188', '189', 'America/Chicago', '2011-05-14', 'Ladue Saint Louis County Missouri US', 'US.MO', 'US.MO.189');

INSERT INTO "public"."first_level_divisions" ("id", "name", "ascii_name", "geoname_id", "abbreviation") VALUES
('US.MD', 'Maryland', 'Maryland', '4361885', 'MD'),
('US.WI', 'Wisconsin', 'Wisconsin', '5279468', 'WI'),
('CA.08', 'Ontario', 'Ontario', '6093943', 'ON'),
('US.OH', 'Ohio', 'Ohio', '5165418', 'OH'),
('US.KY', 'Kentucky', 'Kentucky', '6254925', 'KY'),
('US.CT', 'Connecticut', 'Connecticut', '4831725', 'CT'),
('US.CA', 'California', 'California', '5332921', 'CA'),
('US.NH', 'New Hampshire', 'New Hampshire', '5090174', 'NH');

INSERT INTO "public"."second_level_divisions" ("id", "name", "ascii_name", "geoname_id") VALUES
('US.OH.097', 'Madison County', 'Madison County', '4517365'),
('US.CA.037', 'Los Angeles County', 'Los Angeles County', '5368381'),
('US.NH.015', 'Rockingham County', 'Rockingham County', '5091860'),
('US.KY.125', 'Laurel County', 'Laurel County', '4297480'),
('US.CT.011', 'New London County', 'New London County', '4839420'),
('US.WI.135', 'Waupaca County', 'Waupaca County', '5278089'),
('US.MD.003', 'Anne Arundel County', 'Anne Arundel County', '4347283');

INSERT INTO "public"."alternate_names" ("id", "geoname_id", "extra", "alternate_name", "extra1", "extra2", "extra3", "extra4", "extra5", "extra6") VALUES
('1609996', '6058560', 'de', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1609997', '6058560', 'en', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1609998', '6058560', 'es', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1609999', '6058560', 'et', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1610001', '6058560', 'fr', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1610003', '6058560', 'pl', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1610004', '6058560', 'pt', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1643358', '6058560', 'fi', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('1905354', '6058560', 'eo', 'Londono', NULL, NULL, NULL, NULL, NULL, NULL),
('1993363', '6058560', 'nl', 'London', NULL, NULL, NULL, NULL, NULL, NULL),
('8203478', '6058560', 'lt', 'Londonas', NULL, NULL, NULL, NULL, NULL, NULL),
('1627052', '4839416', 'ca', 'Nova Londres', NULL, NULL, NULL, NULL, NULL, NULL),
('13060772', '4839416', 'en', 'New London', '1', NULL, NULL, NULL, NULL, NULL),
('9061995', '4298960', 'en', 'London', '1', NULL, NULL, NULL, NULL, NULL),
('12892450', '4361094', 'en', 'Londontowne', '1', NULL, NULL, NULL, NULL, NULL),
('11405585', '5088905', 'vep', 'Londonderri', NULL, NULL, NULL, NULL, NULL, NULL),
('12930018', '5088905', 'en', 'Londonderry', '1', NULL, NULL, NULL, NULL, NULL),
('12831037', '4517009', 'en', 'London', '1', NULL, NULL, NULL, NULL, NULL);
