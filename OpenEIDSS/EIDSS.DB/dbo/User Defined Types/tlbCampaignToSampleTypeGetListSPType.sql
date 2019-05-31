CREATE TYPE [dbo].[tlbCampaignToSampleTypeGetListSPType] AS TABLE (
    [CampaignToSampleTypeUID] BIGINT         NOT NULL,
    [idfCampaign]             BIGINT         NOT NULL,
    [idfsSpeciesType]         BIGINT         NULL,
    [SpeciesTypeName]         NVARCHAR (200) NULL,
    [idfsSampleType]          BIGINT         NULL,
    [SampleTypeName]          NVARCHAR (200) NULL,
    [intOrder]                INT            NOT NULL,
    [intRowStatus]            INT            NOT NULL,
    [intPlannedNumber]        INT            NULL,
    [strMaintenanceFlag]      NVARCHAR (20)  NULL,
    [RecordAction]            NCHAR (1)      NULL,
    PRIMARY KEY CLUSTERED ([CampaignToSampleTypeUID] ASC));

