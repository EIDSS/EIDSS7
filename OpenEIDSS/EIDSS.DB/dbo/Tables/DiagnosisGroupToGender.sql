CREATE TABLE [dbo].[DiagnosisGroupToGender] (
    [DisgnosisGroupToGenderUID] BIGINT           NOT NULL,
    [DisgnosisGroupID]          BIGINT           NULL,
    [GenderID]                  BIGINT           NULL,
    [rowguid]                   UNIQUEIDENTIFIER NOT NULL,
    [intRowStatus]              INT              NOT NULL,
    [AuditCreateUser]           VARCHAR (100)    NOT NULL,
    [AuditCreateDTM]            DATETIME         DEFAULT (getdate()) NOT NULL,
    [AuditUpdateUser]           VARCHAR (100)    NULL,
    [AuditUpdateDTM]            DATETIME         NULL,
    [SourceSystemNameID]        BIGINT           NULL,
    [SourceSystemKeyValue]      NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKDiagnosisToGender] PRIMARY KEY CLUSTERED ([DisgnosisGroupToGenderUID] ASC),
    CONSTRAINT [FK_DiagnosisGroupToGender_trtBaseReference_DiagnosisGroupID] FOREIGN KEY ([DisgnosisGroupID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_DiagnosisGroupToGender_trtBaseReference_GenderID] FOREIGN KEY ([GenderID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference]),
    CONSTRAINT [FK_DiagnosisGroupToGender_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);

