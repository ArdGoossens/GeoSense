--CLEAN DATABASE

WHILE ( select 	top 1 1
	from sys.objects oo
	where oo.type in ('U','P','FN','V','SN','TF')
	and oo.is_ms_shipped =0 )=1 or (select top 1 1	from sys.partition_schemes)=1 or (select top 1 1	from sys.partition_functions)=1 
begin
	-- cursor om alle objecten uit een database te halen
	DECLARE Dropper CURSOR
	KEYSET
	FOR  	select regel from (
		select 	0 as volgorde,  'ALTER TABLE ['+S.name+'].['+P.name+'] DROP CONSTRAINT ['+O.name+']'
			 as regel
		from sys.objects O
		inner join sys.schemas S
		on O.schema_id=S.schema_id
		left join sys.objects P
		on O.parent_object_id=P.object_id
		where O.type in ('F')
		and O.is_ms_shipped =0
		and S.name not in ('sys')

		union
		select 	1 as volgorde, case O.type	when 'U' then 'Drop TABLE ['+S.name +'].['+O.name+']'
					when 'P' then 'Drop PROC ['+S.name +'].['+O.name+']'
					when 'FN' then 'Drop FUNCTION ['+S.name +'].['+O.name+']'
					when 'TF' then 'Drop FUNCTION ['+S.name +'].['+O.name+']'
					when 'V' then 'Drop view ['+S.name +'].['+O.name+']'
					when 'SN' then 'Drop synonym ['+S.name +'].['+O.name+']'
			end as regel
		from sys.objects O
		inner join sys.schemas S
		on O.schema_id=S.schema_id
		where O.type in ('U','P','FN','V','SN','TF')
		and O.is_ms_shipped =0
		and S.name not in ('sys')
		union
		select 3 as volgorde,'DROP PARTITION function ' +p.name
	from sys.partition_functions p
	UNION
		select 2 as volgorde,'DROP PARTITION SCHEME ' +p.name
		from sys.partition_schemes p
	UNION
		select 9 as volgorde,'DROP SCHEMA [' +name+']'
		from sys.schemas
		where name not like 'db[_]%'
		and name not in ('guest','INFORMATION_SCHEMA','dbo','sys')
	) bron
	ORDER BY volgorde asc, regel desc

	DECLARE @Regel varchar(1000)
	--DECLARE @volgorde varchar(1000)
	OPEN Dropper

	FETCH NEXT FROM Dropper INTO @Regel
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			print @Regel
			exec (@Regel)
		END
		FETCH NEXT FROM Dropper INTO @Regel
	END

	CLOSE Dropper
	DEALLOCATE Dropper
end
go

select S.name, oo.* from  sys.objects oo
inner join sys.schemas S
on S.schema_id=oo.schema_id
where type not in ('S','SQ','IT')
and S.name not in ('sys')


go
-- CREATE SCHEMA's

CREATE SCHEMA DB
go
CREATE SCHEMA geo
go



--CREATE TABLE
	CREATE TABLE [geo].[Attribute](
		[AttributeID] [int] IDENTITY(1,1) NOT NULL,
		[DatafeedID] [int] NOT NULL,
		[AttributeLabel] [varchar](100) NOT NULL,
		[AttributePath] [varchar](4000) NOT NULL,
		[AttributeDataType] [varchar](100) NULL,
		[AttributeIncluded] [bit] NULL,
		[IdentifiableAttribute] [bit] NULL,
	PRIMARY KEY CLUSTERED 
	(
		[AttributeID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[AttributeValueDate](
		[MeasurementID] [bigint] NOT NULL,
		[AttributeID] [int] NOT NULL,
		[AttributeValue] [datetime2](7) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[MeasurementID] ASC,
		[AttributeID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[AttributeValueNumeric](
		[MeasurementID] [bigint] NOT NULL,
		[AttributeID] [int] NOT NULL,
		[AttributeValue] [numeric](38, 12) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[MeasurementID] ASC,
		[AttributeID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[AttributeValueText](
		[MeasurementID] [bigint] NOT NULL,
		[AttributeID] [int] NOT NULL,
		[AttributeValue] [varchar](4000) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[MeasurementID] ASC,
		[AttributeID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Datafeed](
		[DatafeedID] [int] IDENTITY(1,1) NOT NULL,
		[SourceID] [int] NOT NULL,
		[DatafeedName] [varchar](1000) NOT NULL,
		[EntityType] [varchar](100) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[DatafeedID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[DatafeedDetails](
		[DatafeedID] [int] NOT NULL,
		[AttributeEntityName] [int] NOT NULL,
		[AttributeStartDate] [int] NOT NULL,
		[AttributeGeography] [int]  NULL
	PRIMARY KEY CLUSTERED 
	(
		[DatafeedID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[DataSource](
		[SourceID] [int] IDENTITY(1,1) NOT NULL,
		[SourceName] [varchar](1000) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[SourceID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Entity](
		[EntityID] [int] IDENTITY(1,1) NOT NULL,
		[SourceID] [int] NOT NULL,
		[EntityType] [varchar](100) NOT NULL,
		[EntityValue] [varchar](1000) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[EntityID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Geospatial](
		[LocationID] [bigint] IDENTITY(1,1) NOT NULL,
		[LocationValue] [geography] NOT NULL,
		[SpatialDataType] [varchar](100) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[LocationID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Measurement](
		[MeasurementID] [bigint] IDENTITY(1,1) NOT NULL,
		[DatafeedID] [int] NOT NULL,
		[EntityID] [int] NOT NULL,
		[LocationID] [bigint] NOT NULL,
		[StartDate] [datetime2](7) NOT NULL,
		[StatusCode] [tinyint] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[MeasurementID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[RefreshDatamart](
		DatamartID int NOT NULL,
		[StartDate] [datetime2](7) NOT NULL,
		[EndDate] [datetime2](7) NOT NULL,
		[RefreshStatus] [tinyint] NOT NULL
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Staging](
		[DatafeedID] [int] NOT NULL,
		[FileName] [varchar](1000) NOT NULL,
		[EntityValue] [varchar](1000) NOT NULL,
		[LocationValue] [varchar](1000) NOT NULL,
		[StartDate] [datetime2](7) NOT NULL,
		[AttributePath] [varchar](1000) NOT NULL,
		[AttributeValue] [varchar](4000) NOT NULL
	) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[DatamartAttribute](
		[DatamartID] [int] NOT NULL,
		[AttributeID] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[DatamartID] ASC,
		[AttributeID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO

--CREATE INDEXES
	CREATE UNIQUE NONCLUSTERED INDEX [UI_Datafeed_DatafeedName] ON [geo].[Datafeed]
	(
		[DatafeedName] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	GO

	CREATE UNIQUE NONCLUSTERED INDEX [UI_DataSource_SourceName] ON [geo].[DataSource]
	(
		[SourceName] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	GO

	CREATE NONCLUSTERED INDEX [IX_Measurement_DatafeedID_StartDate] ON [geo].[Measurement]
	(
		DatafeedID, StartDate
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
	GO

	CREATE TABLE [geo].[Datamart](
		[DatamartID] int identity(1,1),
		DatamartName varchar(100) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[DatamartID] ASC
	)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	GO


-- CREATE FOREIGN KEYS
	ALTER TABLE [geo].[Attribute]  WITH CHECK ADD  CONSTRAINT [FK_Attribute_Datafeed] FOREIGN KEY([DatafeedID])
	REFERENCES [geo].[Datafeed] ([DatafeedID])
	ALTER TABLE [geo].[Attribute] CHECK CONSTRAINT [FK_Attribute_Datafeed]
	GO
	ALTER TABLE [geo].[AttributeValueDate]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueDate_Attribute] FOREIGN KEY([AttributeID])
	REFERENCES [geo].[Attribute] ([AttributeID])
	ALTER TABLE [geo].[AttributeValueDate] NOCHECK CONSTRAINT [FK_AttributeValueDate_Attribute]
	GO
	ALTER TABLE [geo].[AttributeValueDate]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueDate_Measurement] FOREIGN KEY([MeasurementID])
	REFERENCES [geo].[Measurement] ([MeasurementID])
	ALTER TABLE [geo].[AttributeValueDate] NOCHECK CONSTRAINT [FK_AttributeValueDate_Measurement]
	GO
	ALTER TABLE [geo].[AttributeValueNumeric]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueNumeric_Attribute] FOREIGN KEY([AttributeID])
	REFERENCES [geo].[Attribute] ([AttributeID])
	ALTER TABLE [geo].[AttributeValueNumeric] NOCHECK CONSTRAINT [FK_AttributeValueNumeric_Attribute]
	GO
	ALTER TABLE [geo].[AttributeValueNumeric]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueNumeric_Measurement] FOREIGN KEY([MeasurementID])
	REFERENCES [geo].[Measurement] ([MeasurementID])
	ALTER TABLE [geo].[AttributeValueNumeric] NOCHECK CONSTRAINT [FK_AttributeValueNumeric_Measurement]
	GO
	ALTER TABLE [geo].[AttributeValueText]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueText_Attribute] FOREIGN KEY([AttributeID])
	REFERENCES [geo].[Attribute] ([AttributeID])
	ALTER TABLE [geo].[AttributeValueText] NOCHECK CONSTRAINT [FK_AttributeValueText_Attribute]
	GO
	ALTER TABLE [geo].[AttributeValueText]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueText_Measurement] FOREIGN KEY([MeasurementID])
	REFERENCES [geo].[Measurement] ([MeasurementID])
	ALTER TABLE [geo].[AttributeValueText] NOCHECK CONSTRAINT [FK_AttributeValueText_Measurement]
	GO
	ALTER TABLE [geo].[DatafeedDetails]  WITH CHECK ADD  CONSTRAINT [FK_DatafeedDetails_Datafeed] FOREIGN KEY([DatafeedID])
	REFERENCES [geo].[Datafeed] ([DatafeedID])
	ALTER TABLE [geo].[DatafeedDetails] CHECK CONSTRAINT [FK_DatafeedDetails_Datafeed]
	GO
	ALTER TABLE [geo].[Datafeed]  WITH CHECK ADD  CONSTRAINT [FK_Datafeed_DataSource] FOREIGN KEY([SourceID])
	REFERENCES [geo].[DataSource] ([SourceID])
	ALTER TABLE [geo].[Datafeed] CHECK CONSTRAINT [FK_Datafeed_DataSource]
	GO
	ALTER TABLE [geo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_DataSource] FOREIGN KEY([SourceID])
	REFERENCES [geo].[DataSource] ([SourceID])
	ALTER TABLE [geo].[Entity] CHECK CONSTRAINT [FK_Entity_DataSource]
	GO
	ALTER TABLE [geo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Datafeed] FOREIGN KEY([DatafeedID])
	REFERENCES [geo].[Datafeed] ([DatafeedID])
	ALTER TABLE [geo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Datafeed]
	GO
	ALTER TABLE [geo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Entity] FOREIGN KEY([EntityID])
	REFERENCES [geo].[Entity] ([EntityID])
	ALTER TABLE [geo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Entity]
	GO
	ALTER TABLE [geo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Geospatial] FOREIGN KEY([LocationID])
	REFERENCES [geo].[Geospatial] ([LocationID])
	ALTER TABLE [geo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Geospatial]
	GO
	ALTER TABLE [geo].[DatamartAttribute]  WITH NOCHECK ADD  CONSTRAINT [FK_DatamartAttribute_Attribute] FOREIGN KEY([AttributeID])
	REFERENCES [geo].[Attribute] ([AttributeID])
	ALTER TABLE [geo].[DatamartAttribute] NOCHECK CONSTRAINT [FK_DatamartAttribute_Attribute]
	GO

	ALTER TABLE [geo].[DatamartAttribute]  WITH CHECK ADD  CONSTRAINT [FK_DatamartAttribute_Datamart] FOREIGN KEY([DatamartID])
	REFERENCES [geo].[Datamart] ([DatamartID])
	ALTER TABLE [geo].[DatamartAttribute] CHECK CONSTRAINT [FK_DatamartAttribute_Datamart]
	GO

	ALTER TABLE [geo].[RefreshDatamart]  WITH CHECK ADD  CONSTRAINT [FK_RefreshDatamart_Datamart] FOREIGN KEY([DatamartID])
	REFERENCES [geo].[Datamart] ([DatamartID])
	ALTER TABLE [geo].[RefreshDatamart] CHECK CONSTRAINT [FK_RefreshDatamart_Datamart]
	GO




--STORED PROCEDURES 
create proc [geo].[stp_DataChanged] (@DatafeedID int, @StartDate datetime2, @EndDate datetime2) as
begin
	declare @StartDateReal datetime2
	declare @EndDateReal datetime2

	-- find the real dates ( of the previous or next measurement)
	set @StartDateReal = isnull(
		(select  max(StartDate) 
		from [geo].[Measurement] M
		where DatafeedID=@DatafeedID
			and StartDate <@StartDate),'1-1-1900')

	set @EndDateReal = isnull(
		(select  min(StartDate) 
		from [geo].[Measurement] M
		where DatafeedID=@DatafeedID
			and StartDate > @StartDate),'31-12-9999')

	-- determine the new refreshwindows for the Datamarts
	select DMA.DatamartID,@StartDateReal StartDate , @EndDateReal EndDate
	into #New
	from [geo].[DatamartAttribute] DMA
	inner join [geo].[Attribute] A
	on A.[AttributeID] = DMA.[AttributeID]
	where A.DatafeedID= @DatafeedID

	-- if the new enddate falls after an existing window but the new startdate is earlier than the start that window
	update RDM
	set RDM.StartDate = N.StartDate
	from [geo].[RefreshDatamart] RDM
	inner join #new N
	on N.DatamartID=RDM.DatamartID
	and RDM.RefreshStatus=0
	where N.StartDate < RDM.StartDate and N.EndDate >= RDM.StartDate
		
	-- if the new startdate falls before an existing window but the new enddate is later than the end of that window
	update RDM
	set RDM.EndDate = N.EndDate
	from [geo].[RefreshDatamart] RDM
	inner join #new N
	on N.DatamartID=RDM.DatamartID
	and RDM.RefreshStatus=0
	where N.EndDate > RDM.StartDate and N.StartDate <= RDM.EndDate

	-- delete the records that are already covered in the existing (updated) refresh windows.
	delete from N
	from [geo].[RefreshDatamart] RDM
	inner join #new N
	on N.DatamartID=RDM.DatamartID
	and RDM.RefreshStatus=0
	where N.StartDate>= RDM.StartDate and N.EndDate<=RDM.EndDate

	-- add refreshwindows not covered by the existing ones.
	insert into [geo].[RefreshDatamart] (DatamartID, StartDate,EndDate,RefreshStatus)
	select  DatamartID, StartDate,EndDate, 0
	from #New

end
go


--TESTS
create view [DB].[Datamart] as 

SELECT [DatamartName]
  FROM [geo].[Datamart]
GO


/****** Object:  UserDefinedFunction [geo].[tablefunction]    Script Date: 21-8-2020 09:10:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [geo].[tablefunction]
( @filename varchar(100))
RETURNS @Result TABLE 
( Name varchar(100), Value varchar(100)
)
AS
BEGIN

declare @DM TABLE( DatamartID int, [DatamartName] varchar(100))
insert @DM
select DatamartID,[DatamartName]
from [geo].[Datamart]

	insert @Result
	select DatamartID,[DatamartName]
	from @DM
	RETURN 
END
GO


create table geo.StagingAttributes(
Filename varchar(1000),
path varchar(1000))


-- DATA

insert into geo.DataSource select 'DINOBRO'
insert into geo.DataSource select 'SUNFLOWER'

insert into geo.Datafeed (DatafeedName, SourceID,EntityType) select 'DINOBRO_Entities', (select [SourceID] from geo.DataSource where SourceName='DINOBRO'),'Type1'
insert into geo.Datafeed (DatafeedName, SourceID,EntityType)select 'DINOBRO_EntityDescriptions', (select [SourceID] from geo.DataSource where SourceName='DINOBRO'),'Type1'
insert into geo.Datafeed (DatafeedName, SourceID,EntityType)select 'DINOBRO_TimeEntities', (select [SourceID] from geo.DataSource where SourceName='DINOBRO'),'Type1'
insert into geo.Datafeed (DatafeedName, SourceID,EntityType)select 'SUNFLOWER_Entities', (select [SourceID] from geo.DataSource where SourceName='SUNFLOWER'),'Type2'
insert into geo.Datafeed (DatafeedName, SourceID,EntityType)select 'SUNFLOWER_EntityDescriptions', (select [SourceID] from geo.DataSource where SourceName='SUNFLOWER'),'Type2'
insert into geo.Datafeed (DatafeedName, SourceID,EntityType)select 'SUNFLOWER_TimeEntities', (select [SourceID] from geo.DataSource where SourceName='SUNFLOWER'),'Type2'
declare @DINOBRO_Entities int
SELECT  @DINOBRO_Entities =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='DINOBRO_Entities'
declare @DINOBRO_EntityDescriptions int
SELECT  @DINOBRO_EntityDescriptions =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='DINOBRO_EntityDescriptions'
declare @DINOBRO_TimeEntities int
SELECT  @DINOBRO_TimeEntities =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='DINOBRO_TimeEntities'
declare @SUNFLOWER_Entities int
SELECT  @SUNFLOWER_Entities =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='SUNFLOWER_Entities'
declare @SUNFLOWER_EntityDescriptions int
SELECT  @SUNFLOWER_EntityDescriptions =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='SUNFLOWER_EntityDescriptions'
declare @SUNFLOWER_TimeEntities int
SELECT  @SUNFLOWER_TimeEntities =[DatafeedID] FROM [geo].[Datafeed] where DatafeedName='SUNFLOWER_TimeEntities'

insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'Created', '`Created`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'CustomerName', '`CustomerName`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'EntityDescriptionId', '`EntityDescriptionId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'ExternalId', '`ExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'Location.coordinates', '`Location`.`coordinates`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'Location.type', '`Location`.`type`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_Entities, 'TimeEntityIds', '`TimeEntityIds`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Created', '`Created`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.brocom:broId', '`Data`.`brocom:broId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.brocom:deliveryAccountableParty', '`Data`.`brocom:deliveryAccountableParty`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.brocom:qualityRegime', '`Data`.`brocom:qualityRegime`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.constructionStandard.#text', '`Data`.`constructionStandard`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.constructionStandard.@codeSpace', '`Data`.`constructionStandard`.`@codeSpace`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.constructionStandard.@xmlns', '`Data`.`constructionStandard`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.deliveryContext.#text', '`Data`.`deliveryContext`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.initialFunction.#text', '`Data`.`initialFunction`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.initialFunction.@codeSpace', '`Data`.`initialFunction`.`@codeSpace`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.initialFunction.@xmlns', '`Data`.`initialFunction`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.nitgCode.#text', '`Data`.`nitgCode`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.deliveryContext.@codeSpace', '`Data`.`deliveryContext`.`@codeSpace`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.deliveryContext.@xmlns', '`Data`.`deliveryContext`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.groundLevelStable.#text', '`Data`.`groundLevelStable`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.groundLevelStable.@xmlns', '`Data`.`groundLevelStable`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.nitgCode.@xmlns', '`Data`.`nitgCode`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.numberOfMonitoringTubes.#text', '`Data`.`numberOfMonitoringTubes`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.numberOfMonitoringTubes.@xmlns', '`Data`.`numberOfMonitoringTubes`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.owner.#text', '`Data`.`owner`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.wellStability.@xmlns', '`Data`.`wellStability`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.withPrehistory.#text', '`Data`.`withPrehistory`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.withPrehistory.@xmlns', '`Data`.`withPrehistory`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'EntityExternalId', '`EntityExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.owner.@xmlns', '`Data`.`owner`.`@xmlns`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.result', '`Data`.`result`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.wellStability.#text', '`Data`.`wellStability`.`#text`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Data.wellStability.@codeSpace', '`Data`.`wellStability`.`@codeSpace`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_EntityDescriptions, 'Valid', '`Valid`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'CustomerName', '`CustomerName`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'EntityExternalId', '`EntityExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeResolution', '`TimeResolution`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Id', '`TimeSerieDtos`.`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Tags.FILTERNUMMER', '`TimeSerieDtos`.`Tags`.`FILTERNUMMER`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Tags.LOCATIE', '`TimeSerieDtos`.`Tags`.`LOCATIE`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Tags.TEST', '`TimeSerieDtos`.`Tags`.`TEST`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Time', '`TimeSerieDtos`.`Time`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.TimeEntityId', '`TimeSerieDtos`.`TimeEntityId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSerieDtos.Value', '`TimeSerieDtos`.`Value`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @DINOBRO_TimeEntities, 'TimeSeriesTagSelector.FILTERNUMMER', '`TimeSeriesTagSelector`.`FILTERNUMMER`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'EntityDescriptionId', '`EntityDescriptionId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'ExternalId', '`ExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'Location.coordinates', '`Location`.`coordinates`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'Location.type', '`Location`.`type`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'TimeEntityIds', '`TimeEntityIds`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'CustomerName', '`CustomerName`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_Entities, 'Created', '`Created`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Data.Name', '`Data`.`Name`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'EntityExternalId', '`EntityExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Valid', '`Valid`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Created', '`Created`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Data.Details.Internal id', '`Data`.`Details`.`Internal id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_EntityDescriptions, 'Data.Details.Manufacturer', '`Data`.`Details`.`Manufacturer`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'CustomerName', '`CustomerName`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'EntityExternalId', '`EntityExternalId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSerieDtos.Id', '`TimeSerieDtos`.`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSerieDtos.Tags', '`TimeSerieDtos`.`Tags`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSerieDtos.Time', '`TimeSerieDtos`.`Time`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSerieDtos.TimeEntityId', '`TimeSerieDtos`.`TimeEntityId`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'Id', '`Id`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeResolution', '`TimeResolution`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSerieDtos.Value', '`TimeSerieDtos`.`Value`'
insert into geo.Attribute ([DatafeedID], [AttributeLabel], [AttributePath]) select @SUNFLOWER_TimeEntities, 'TimeSeriesTagSelector', '`TimeSeriesTagSelector`'


insert into [geo].[DatafeedDetails](
[DatafeedID], [AttributeEntityName], [AttributeStartDate], [AttributeGeography])
select 
	DF.[DatafeedID], 
	[AttributeEntityName], 
	[AttributeStartDate], 
	[AttributeGeography]
from geo.Datafeed DF
left join (select DatafeedID, AttributeID [AttributeStartDate] from [geo].Attribute SA where [AttributePath] in( '`Created`','`TimeSerieDtos`.`Time`' )) SD
on DF.DatafeedID=SD.DatafeedID
left join (select DatafeedID, AttributeID [AttributeEntityName] from [geo].Attribute SA where [AttributePath] in( '`EntityExternalId`','`ExternalId`' )) EN
on DF.DatafeedID=EN.DatafeedID
left join (select DatafeedID, AttributeID [AttributeGeography] from [geo].Attribute SA where [AttributePath] in( '`Location`.`coordinates`' )) G
on DF.DatafeedID=G.DatafeedID


-- the mandatory fields are always used for identification
update A
set IdentifiableAttribute=1
from geo.Attribute A
inner join geo.DatafeedDetails DFD
on (DFD.AttributeEntityName=A.AttributeID
or DFD.AttributeGeography=A.AttributeID
or DFD.AttributeStartDate=A.AttributeID)




