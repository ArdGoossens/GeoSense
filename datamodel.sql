-- DROP FOREIGN KEYS 

ALTER TABLE [dbo].[Measurement] DROP CONSTRAINT [FK_Measurement_Geospatial]
GO

ALTER TABLE [dbo].[Measurement] DROP CONSTRAINT [FK_Measurement_Entity]
GO

ALTER TABLE [dbo].[Measurement] DROP CONSTRAINT [FK_Measurement_DataFeed]
GO

ALTER TABLE [dbo].[Entity] DROP CONSTRAINT [FK_Entity_DataSource]
GO

ALTER TABLE [dbo].[DataFeed] DROP CONSTRAINT [FK_DataFeed_DataSource]
GO

ALTER TABLE [dbo].[DataFeed] DROP CONSTRAINT [FK_DataFeed_DataFeedDetais]
GO

ALTER TABLE [dbo].[AttributeValueText] DROP CONSTRAINT [FK_AttributeValueText_Measurement]
GO

ALTER TABLE [dbo].[AttributeValueText] DROP CONSTRAINT [FK_AttributeValueText_Attribute]
GO

ALTER TABLE [dbo].[AttributeValueNumeric] DROP CONSTRAINT [FK_AttributeValueNumeric_Measurement]
GO

ALTER TABLE [dbo].[AttributeValueNumeric] DROP CONSTRAINT [FK_AttributeValueNumeric_Attribute]
GO

ALTER TABLE [dbo].[AttributeValueDate] DROP CONSTRAINT [FK_AttributeValueDate_Measurement]
GO

ALTER TABLE [dbo].[AttributeValueDate] DROP CONSTRAINT [FK_AttributeValueDate_Attribute]
GO

ALTER TABLE [dbo].[Attribute] DROP CONSTRAINT [FK_Attribute_DataFeed]
GO

--DROP INDEX (nvt)


--DROP TABLE
			/****** Object:  Table [dbo].[Staging]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[Staging]
			GO

			/****** Object:  Table [dbo].[RefreshDataMart]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[RefreshDataMart]
			GO

			/****** Object:  Table [dbo].[Measurement]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[Measurement]
			GO

			/****** Object:  Table [dbo].[MartFeeds]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[MartFeeds]
			GO

			/****** Object:  Table [dbo].[Geospatial]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[Geospatial]
			GO

			/****** Object:  Table [dbo].[Entity]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[Entity]
			GO

			/****** Object:  Table [dbo].[DataSource]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[DataSource]
			GO

			/****** Object:  Table [dbo].[DataFeedDetais]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[DataFeedDetais]
			GO

			/****** Object:  Table [dbo].[DataFeed]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[DataFeed]
			GO

			/****** Object:  Table [dbo].[AttributeValueText]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[AttributeValueText]
			GO

			/****** Object:  Table [dbo].[AttributeValueNumeric]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[AttributeValueNumeric]
			GO

			/****** Object:  Table [dbo].[AttributeValueDate]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[AttributeValueDate]
			GO

			/****** Object:  Table [dbo].[Attribute]    Script Date: 18-8-2020 15:23:12 ******/
			DROP TABLE [dbo].[Attribute]
			GO


--CREATE TABLE
			/****** Object:  Table [dbo].[Attribute]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[Attribute](
				[AttributeID] [int] IDENTITY(1,1) NOT NULL,
				[DataFeedID] [int] NOT NULL,
				[AttributeLabel] [varchar](100) NOT NULL,
				[AttributePath] [varchar](4000) NOT NULL,
				[AttributeDataType] [varchar](100) NOT NULL,
				[AttributeIncluded] [bit] NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[AttributeID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[AttributeValueDate]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[AttributeValueDate](
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

			/****** Object:  Table [dbo].[AttributeValueNumeric]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[AttributeValueNumeric](
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

			/****** Object:  Table [dbo].[AttributeValueText]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[AttributeValueText](
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

			/****** Object:  Table [dbo].[DataFeed]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[DataFeed](
				[DataFeedID] [int] IDENTITY(1,1) NOT NULL,
				[SourceID] [int] NOT NULL,
				[DataFeedName] [varchar](1000) NOT NULL,
				[EntityType] [varchar](100) NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[DataFeedID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[DataFeedDetais]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[DataFeedDetais](
				[DataFeedID] [int] NOT NULL,
				[AttributeEntiryName] [int] NOT NULL,
				[AttributeGeography] [int] NOT NULL,
				[AttibuteSourceName] [int] NOT NULL,
				[SpatialDataType] [varchar](100) NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[DataFeedID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[DataSource]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[DataSource](
				[SourceID] [int] IDENTITY(1,1) NOT NULL,
				[SourceName] [varchar](1000) NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[SourceID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[Entity]    Script Date: 18-8-2020 15:23:12 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[Entity](
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

			/****** Object:  Table [dbo].[Geospatial]    Script Date: 18-8-2020 15:23:13 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[Geospatial](
				[LocationID] [bigint] IDENTITY(1,1) NOT NULL,
				[LocationValue] [geography] NOT NULL,
				[SpatialDataType] [varchar](100) NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[LocationID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[MartFeeds]    Script Date: 18-8-2020 15:23:13 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[MartFeeds](
				[DataMart] [varchar](100) NOT NULL,
				[DataFeedID] [int] NOT NULL,
			PRIMARY KEY CLUSTERED 
			(
				[DataMart] ASC,
				[DataFeedID] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[Measurement]    Script Date: 18-8-2020 15:23:13 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[Measurement](
				[MeasurementID] [bigint] IDENTITY(1,1) NOT NULL,
				[DataFeedID] [int] NOT NULL,
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

			/****** Object:  Table [dbo].[RefreshDataMart]    Script Date: 18-8-2020 15:23:13 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[RefreshDataMart](
				[DataMart] [varchar](100) NOT NULL,
				[StartDate] [datetime2](7) NOT NULL,
				[EndDate] [datetime2](7) NOT NULL,
				[RefreshStatus] [tinyint] NOT NULL
			) ON [PRIMARY]
			GO

			/****** Object:  Table [dbo].[Staging]    Script Date: 18-8-2020 15:23:13 ******/
			SET ANSI_NULLS ON
			GO

			SET QUOTED_IDENTIFIER ON
			GO

			CREATE TABLE [dbo].[Staging](
				[DataFeedID] [int] NOT NULL,
				[FileName] [varchar](1000) NOT NULL,
				[EntityValue] [varchar](1000) NOT NULL,
				[LocationValue] [varchar](1000) NOT NULL,
				[StartDate] [datetime2](7) NOT NULL,
				[AttributePath] [varchar](1000) NOT NULL,
				[AttributeValue] [varchar](4000) NOT NULL
			) ON [PRIMARY]
			GO

			SET ANSI_PADDING ON
			GO
--CREATE INDEXES
			/****** Object:  Index [UI_DataFeed_DataFeedName]    Script Date: 18-8-2020 15:23:13 ******/
			CREATE UNIQUE NONCLUSTERED INDEX [UI_DataFeed_DataFeedName] ON [dbo].[DataFeed]
			(
				[DataFeedName] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
			GO

			SET ANSI_PADDING ON
			GO

			/****** Object:  Index [UI_DataSource_SourceName]    Script Date: 18-8-2020 15:23:13 ******/
			CREATE UNIQUE NONCLUSTERED INDEX [UI_DataSource_SourceName] ON [dbo].[DataSource]
			(
				[SourceName] ASC
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
			GO

			/****** Object:  Index [[IX_Measurement_DataFeedID_StartDate]]    Script Date: 18-8-2020 15:23:13 ******/
			CREATE NONCLUSTERED INDEX [IX_Measurement_DataFeedID_StartDate] ON [dbo].[Measurement]
			(
				DataFeedID, StartDate
			)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
			GO


-- CREATE FOREIGN KEYS
			ALTER TABLE [dbo].[Attribute]  WITH CHECK ADD  CONSTRAINT [FK_Attribute_DataFeed] FOREIGN KEY([DataFeedID])
			REFERENCES [dbo].[DataFeed] ([DataFeedID])
			GO

			ALTER TABLE [dbo].[Attribute] CHECK CONSTRAINT [FK_Attribute_DataFeed]
			GO

			ALTER TABLE [dbo].[AttributeValueDate]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueDate_Attribute] FOREIGN KEY([AttributeID])
			REFERENCES [dbo].[Attribute] ([AttributeID])
			GO

			ALTER TABLE [dbo].[AttributeValueDate] NOCHECK CONSTRAINT [FK_AttributeValueDate_Attribute]
			GO

			ALTER TABLE [dbo].[AttributeValueDate]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueDate_Measurement] FOREIGN KEY([MeasurementID])
			REFERENCES [dbo].[Measurement] ([MeasurementID])
			GO

			ALTER TABLE [dbo].[AttributeValueDate] NOCHECK CONSTRAINT [FK_AttributeValueDate_Measurement]
			GO

			ALTER TABLE [dbo].[AttributeValueNumeric]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueNumeric_Attribute] FOREIGN KEY([AttributeID])
			REFERENCES [dbo].[Attribute] ([AttributeID])
			GO

			ALTER TABLE [dbo].[AttributeValueNumeric] NOCHECK CONSTRAINT [FK_AttributeValueNumeric_Attribute]
			GO

			ALTER TABLE [dbo].[AttributeValueNumeric]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueNumeric_Measurement] FOREIGN KEY([MeasurementID])
			REFERENCES [dbo].[Measurement] ([MeasurementID])
			GO

			ALTER TABLE [dbo].[AttributeValueNumeric] NOCHECK CONSTRAINT [FK_AttributeValueNumeric_Measurement]
			GO

			ALTER TABLE [dbo].[AttributeValueText]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueText_Attribute] FOREIGN KEY([AttributeID])
			REFERENCES [dbo].[Attribute] ([AttributeID])
			GO

			ALTER TABLE [dbo].[AttributeValueText] NOCHECK CONSTRAINT [FK_AttributeValueText_Attribute]
			GO

			ALTER TABLE [dbo].[AttributeValueText]  WITH NOCHECK ADD  CONSTRAINT [FK_AttributeValueText_Measurement] FOREIGN KEY([MeasurementID])
			REFERENCES [dbo].[Measurement] ([MeasurementID])
			GO

			ALTER TABLE [dbo].[AttributeValueText] NOCHECK CONSTRAINT [FK_AttributeValueText_Measurement]
			GO

			ALTER TABLE [dbo].[DataFeed]  WITH CHECK ADD  CONSTRAINT [FK_DataFeed_DataFeedDetais] FOREIGN KEY([DataFeedID])
			REFERENCES [dbo].[DataFeedDetais] ([DataFeedID])
			GO

			ALTER TABLE [dbo].[DataFeed] CHECK CONSTRAINT [FK_DataFeed_DataFeedDetais]
			GO

			ALTER TABLE [dbo].[DataFeed]  WITH CHECK ADD  CONSTRAINT [FK_DataFeed_DataSource] FOREIGN KEY([SourceID])
			REFERENCES [dbo].[DataSource] ([SourceID])
			GO

			ALTER TABLE [dbo].[DataFeed] CHECK CONSTRAINT [FK_DataFeed_DataSource]
			GO

			ALTER TABLE [dbo].[Entity]  WITH CHECK ADD  CONSTRAINT [FK_Entity_DataSource] FOREIGN KEY([SourceID])
			REFERENCES [dbo].[DataSource] ([SourceID])
			GO

			ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_DataSource]
			GO

			ALTER TABLE [dbo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_DataFeed] FOREIGN KEY([DataFeedID])
			REFERENCES [dbo].[DataFeed] ([DataFeedID])
			GO

			ALTER TABLE [dbo].[Measurement] CHECK CONSTRAINT [FK_Measurement_DataFeed]
			GO

			ALTER TABLE [dbo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Entity] FOREIGN KEY([EntityID])
			REFERENCES [dbo].[Entity] ([EntityID])
			GO

			ALTER TABLE [dbo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Entity]
			GO

			ALTER TABLE [dbo].[Measurement]  WITH CHECK ADD  CONSTRAINT [FK_Measurement_Geospatial] FOREIGN KEY([LocationID])
			REFERENCES [dbo].[Geospatial] ([LocationID])
GO

ALTER TABLE [dbo].[Measurement] CHECK CONSTRAINT [FK_Measurement_Geospatial]
GO



--STORED PROCEDURES 


/****** Object:  StoredProcedure [dbo].[stp_DataChanged]    Script Date: 18-8-2020 15:58:23 ******/
DROP PROCEDURE [dbo].[stp_DataChanged]
GO

/****** Object:  StoredProcedure [dbo].[stp_DataChanged]    Script Date: 18-8-2020 15:58:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create proc [dbo].[stp_DataChanged] (@DataFeedID int, @StartDate datetime2, @EndDate datetime2) as
begin
	declare @StartDateReal datetime2
	declare @EndDateReal datetime2

	-- find the real dates ( of the previous or next measurement)
	set @StartDateReal = isnull(
		(select  max(StartDate) 
		from Measurement M
		where DataFeedID=@DataFeedID
			and StartDate <@StartDate),'1-1-1900')

	set @EndDateReal = isnull(
		(select  min(StartDate) 
		from Measurement M
		where DataFeedID=@DataFeedID
			and StartDate > @StartDate),'31-12-9999')

	-- determine the new refreshwindows for the datamarts
	select DataMart,@StartDateReal StartDate , @EndDateReal EndDate
	into #New
	from MartFeeds 
	where DataFeedID= @DataFeedID

	-- if the new enddate falls after an existing window but the new startdate is earlier than the start that window
	update RDM
	set RDM.StartDate = N.StartDate
	from RefreshDataMart RDM
	inner join #new N
	on N.DataMart=RDM.DataMart
	and RDM.RefreshStatus=0
	where N.StartDate < RDM.StartDate and N.EndDate >= RDM.StartDate
		
	-- if the new startdate falls before an existing window but the new enddate is later than the end of that window
	update RDM
	set RDM.EndDate = N.EndDate
	from RefreshDataMart RDM
	inner join #new N
	on N.DataMart=RDM.DataMart
	and RDM.RefreshStatus=0
	where N.EndDate > RDM.StartDate and N.StartDate <= RDM.EndDate

	-- delete the records that are already covered in the existing (updated) refresh windows.
	delete from N
	from RefreshDataMart RDM
	inner join #new N
	on N.DataMart=RDM.DataMart
	and RDM.RefreshStatus=0
	where N.StartDate>= RDM.StartDate and N.EndDate<=RDM.EndDate

	-- add refreshwindows not covered by the existing ones.
	insert into RefreshDataMart (DataMart, StartDate,EndDate,RefreshStatus)
	select  DataMart, StartDate,EndDate, 0
	from #New

end

GO


