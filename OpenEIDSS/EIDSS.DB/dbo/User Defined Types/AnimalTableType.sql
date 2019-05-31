CREATE TYPE [dbo].[AnimalTableType] AS TABLE (
    [AnimalID]              BIGINT         NOT NULL,
    [AnimalGenderTypeID]    BIGINT         NULL,
    [AnimalConditionTypeID] BIGINT         NULL,
    [AnimalAgeTypeID]       BIGINT         NULL,
    [SpeciesID]             BIGINT         NULL,
    [Description]           NVARCHAR (200) NULL,
    [AnimalEIDSSID]         NVARCHAR (200) NULL,
    [Name]                  NVARCHAR (200) NULL,
    [Color]                 NVARCHAR (200) NULL,
    [RowStatus]             INT            NOT NULL,
    [RecordAction]          NCHAR (1)      NOT NULL,
    PRIMARY KEY CLUSTERED ([AnimalID] ASC));

