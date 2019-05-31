CREATE TYPE [dbo].[tlbOMMSpeciesParameters] AS TABLE (
    [idfOutbreak]             BIGINT        NOT NULL,
    [OutbreakSpeciesTypeID]   BIGINT        NOT NULL,
    [CaseMonitoringDuration]  INT           NULL,
    [CaseMonitoringFrequency] INT           NULL,
    [ContactTracingDuration]  INT           NULL,
    [ContactTracingFrequency] INT           NULL,
    [intRowStatus]            INT           NULL,
    [AuditCreateUser]         VARCHAR (100) NOT NULL,
    [AuditCreateDTM]          DATETIME      NOT NULL,
    [AuditUpdateUser]         VARCHAR (100) NOT NULL,
    [AuditUpdateDTM]          DATETIME      NULL);

