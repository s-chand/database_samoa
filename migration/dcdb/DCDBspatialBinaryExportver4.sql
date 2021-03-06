-- Updated version provided by Neil on 4th May 2012
-- Updated on 20th Jun 2012 by Andrew following corrections to RCL table. 
--Updated on 15 September 2012 by Neil to include ROADPOLYGON
USE DCDB
--Remove Spatialware Indexes
declare @tbl as varchar(32)
declare @own as varchar(32)
declare @spatial as varchar(32)
declare @rend_type as int
declare @rend_col as varchar(32)
declare tblcursor cursor for select TABLENAME, OWNERNAME, SPATIALCOLUMN, RENDITIONTYPE, RENDITIONCOLUMN from mapinfo.mapinfo_mapcatalog

open tblcursor

-- Fetch First Record
FETCH NEXT FROM tblcursor
INTO @tbl, @own, @spatial, @rend_type, @rend_col

-- @@FETCH STATUS INDICATES ADDITIONAL RECORDS
WHILE @@FETCH_STATUS = 0
BEGIN
-- Execute Code

-- Drop RTREE
PRINT 'Drop Rtree : ' +@own + '.' + @tbl
exec sp_sw_drop_rtree @own, @tbl, @spatial, 'SW_MEMBER' 

-- DeSpatialize
PRINT 'Despatialize : ' +@own + '.' + @tbl
exec sp_sw_despatialize_column @own, @tbl, @spatial, 'SW_MEMBER'

-- Fetch Next Record
FETCH NEXT FROM tblcursor
INTO @tbl, @own, @spatial, @rend_type, @rend_col
END

CLOSE tblcursor
DEALLOCATE tblcursor

go
-----------------------------------------------------
--Now Create tmp DCDB binary files


IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpCourtGrantbinaryExport' AND xtype='U')
	DROP TABLE tmpCourtGrantbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'COURTGRANTREFERENCEPOINT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpCourtGrantbinaryExport FROM [DCDB].[dbo].[COURTGRANTREFERENCEPOINT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO


IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpParcelbinaryExport' AND xtype='U')
	DROP TABLE tmpParcelbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'DCDBPARCELPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpParcelbinaryExport FROM [DCDB].[dbo].[DCDBPARCELPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpGeodeticMarkbinaryExport' AND xtype='U')
	DROP TABLE tmpGeodeticMarkbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'GEODETICMARKPOINT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpGeodeticMarkbinaryExport FROM [DCDB].[dbo].[GEODETICMARKPOINT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpHydrobinaryExport' AND xtype='U')
	DROP TABLE tmpHydrobinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'HYDROPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpHydrobinaryExport FROM [DCDB].[dbo].[HYDROPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpRoadCentrelinebinaryExport' AND xtype='U')
	DROP TABLE tmpRoadCentrelinebinaryExport
GO	

IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'ROADCENTRELINESEGMENT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpRoadCentrelinebinaryExport FROM [DCDB].[dbo].[ROADCENTRELINESEGMENT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO


IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpRoadbinaryExport' AND xtype='U')
	DROP TABLE tmpRoadbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'ROADPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpRoadbinaryExport FROM [DCDB].[dbo].[ROADPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO


IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpRoadbinaryExport' AND xtype='U')
	DROP TABLE tmpRoadbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'ROADPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpRoadbinaryExport FROM [DCDB].[dbo].[ROADPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpSurveyPlanbinaryExport' AND xtype='U')
	DROP TABLE tmpSurveyPlanbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'SURVEYPLANREFERENCEPOINT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpSurveyPlanbinaryExport FROM [DCDB].[dbo].[SURVEYPLANREFERENCEPOINT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpTopoPointbinaryExport' AND xtype='U')
	DROP TABLE tmpTopoPointbinaryExport
GO	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'TOPOFEATUREPOINT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpTopoPointbinaryExport FROM [DCDB].[dbo].[TOPOFEATUREPOINT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpTopoSegmentbinaryExport' AND xtype='U')
	DROP TABLE tmpTopoSegmentbinaryExport
GO
	
IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'TOPOFEATURESEGMENT') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpTopoSegmentbinaryExport FROM [DCDB].[dbo].[TOPOFEATURESEGMENT] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value

END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpRecordSheetbinaryExport' AND xtype='U')
	DROP TABLE tmpRecordSheetbinaryExport
GO	

IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'RECORDMAPINDEXSHEETS') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpRecordSheetbinaryExport FROM [DCDB].[dbo].[RECORDMAPINDEXSHEETS] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value
END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpUpgradedSLPolybinaryExport' AND xtype='U')
	DROP TABLE tmpUpgradedSLPolybinaryExport
GO	

IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'UPGRADEDRSOUTLINEPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpUpgradedSLPolybinaryExport FROM [DCDB].[dbo].[UPGRADEDRSOUTLINEPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value
END
GO

IF EXISTS(SELECT name FROM [DCDB]..sysobjects WHERE name = N'tmpFlurPolygonbinaryExport' AND xtype='U')
	DROP TABLE tmpFlurPolygonbinaryExport
GO	

IF EXISTS (SELECT TABLENAME FROM [DCDB].[MAPINFO].[MAPINFO_MAPCATALOG] WHERE ((TABLENAME = N'FLURPOLYGON') AND (SUBSTRING([COORDINATESYSTEM],21,3) = '104'))) 
BEGIN
	DECLARE	@return_value int

	EXEC	@return_value = [dbo].[sp_spatial_query]
			@query = N'SELECT SW_MEMBER, HG_AsBinary(SW_GEOMETRY)  AS ogcbinary into tmpFlurPolygonbinaryExport FROM [DCDB].[dbo].[FLURPOLYGON] WHERE SW_GEOMETRY IS NOT NULL AND HG_Is_Valid(SW_GEOMETRY)'

	SELECT	'Return Value' = @return_value
END
GO

-------------------------
--Now remake Spatialware Indexes
USE DCDB
declare @tbl as varchar(32)
declare @own as varchar(32)
declare @spatial as varchar(32)
declare @rend_type as int
declare @rend_col as varchar(32)
declare tblcursor cursor for select TABLENAME, OWNERNAME, SPATIALCOLUMN, RENDITIONTYPE, RENDITIONCOLUMN from mapinfo.mapinfo_mapcatalog

-- Spatialize Current Database
exec sp_spatialize_db

open tblcursor

-- Fetch First Record
FETCH NEXT FROM tblcursor
INTO @tbl, @own, @spatial, @rend_type, @rend_col

-- @@FETCH STATUS INDICATES ADDITIONAL RECORDS
WHILE @@FETCH_STATUS = 0
BEGIN
-- Execute Code
-- Spatialize
PRINT 'Spatialize : ' +@own + '.' + @tbl
exec sp_sw_spatialize_column @own, @tbl, @spatial, 'SW_MEMBER'

-- Create RTREE
PRINT 'Create Rtree : ' +@own + '.' + @tbl
exec sp_sw_create_rtree @own, @tbl, @spatial, 'SW_MEMBER' 

-- Fetch Next Record
FETCH NEXT FROM tblcursor
INTO @tbl, @own, @spatial, @rend_type, @rend_col
END

CLOSE tblcursor
DEALLOCATE tblcursor

go 
