CREATE TABLE [dbo].[tstNotificationActivity] (
    [datLastNotificationActivity] DATETIME         NOT NULL,
    [rowguid]                     UNIQUEIDENTIFIER DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [SourceSystemNameID]          BIGINT           NULL,
    [SourceSystemKeyValue]        NVARCHAR (MAX)   NULL,
    CONSTRAINT [XPKtstNotificationActivity] PRIMARY KEY CLUSTERED ([datLastNotificationActivity] ASC),
    CONSTRAINT [FK_tstNotificationActivity_trtBaseReference_SourceSystemNameID] FOREIGN KEY ([SourceSystemNameID]) REFERENCES [dbo].[trtBaseReference] ([idfsBaseReference])
);

