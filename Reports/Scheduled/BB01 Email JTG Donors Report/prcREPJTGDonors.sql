USE JGReporting;
GO

IF OBJECT_ID('dbo.prcREPJTGDonors') IS NOT NULL DROP PROCEDURE dbo.prcREPJTGDonors;
GO

CREATE PROCEDURE dbo.prcREPJTGDonors (@DateIn DATETIME)
AS

/**************************************************************************************
Procedure	:	prcREPBAJTGDonors
Category 	:	BB01 Email JTG Donors Report
Created By	:	Raul Garcia
DateCreated	:	22/05/2012
Modified	:	
***************************************************************************************/

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE
		@BeginPrevWeek		DATETIME,
		@EndPrevWeek		DATETIME,
		@BeginActWeek		DATETIME;

	SELECT
		@BeginPrevWeek = DATEADD(WW, DATEDIFF(WW, 0, @DateIn)-1, 0),
		@EndPrevWeek = DATEADD(WW, DATEDIFF(WW, 0, @DateIn), 0)-1,
		@BeginActWeek = DATEADD(WW, DATEDIFF(WW, 0, @DateIn), 0);

/*
	IF OBJECT_ID('dbo.tblREPJTGDonors') IS NOT NULL DROP TABLE dbo.tblREPJTGDonors;

	CREATE TABLE dbo.tblREPJTGDonors
	(
		[Date ID]													INT,
		[Date Name]													VARCHAR(30),
		[# of Unique JTG Donors]									BIGINT,
		[# of Unique JTG Donors that Opted-In to JG Comms]			BIGINT,
		[# of Unique JTG Donors that Opted-In to Charity Comms]		BIGINT,
		[# of JTG Donations with GA]								BIGINT,
		[# of JTG Donations]										BIGINT
	);
*/

	DELETE FROM dbo.tblREPJTGDonors WHERE [Date ID] = CONVERT(INT, CONVERT(VARCHAR, @EndPrevWeek, 112));

	WITH A AS
	(
		SELECT
			[# of Unique JTG Donors]	=	COUNT(DISTINCT DURN.Value)
		FROM
			BB01.dbo.BB01_SmsDonation SD
			INNER JOIN BB01.dbo.BB01_DonationLine DL ON SD.DonationLineId = DL.DonationLineId
			INNER JOIN BB01.dbo.tblDURN DURN ON DL.ConsumerId = DURN.ConsumerId
			INNER JOIN BB01.dbo.BB01_FundraiserRevenueStream FRS ON SD.FundraiserRevenueStreamId = FRS.FundraiserRevenueStreamId
			INNER JOIN BB01.dbo.tblFundraiserRevenueStreamMobile FRSM ON SD.FundraiserRevenueStreamId = FRSM.FundraiserRevenueStreamId
		WHERE
			DL.sysDateCreated < @BeginActWeek
			AND FRS.FundraiserId NOT IN
				(
					11318,	--	Oasis UK
					246422,	--	Demo - CRUK 00 - 09
					246423,	--	Demo - CRUK 10 - 19
					246424,	--	Demo - CRUK 20 - 29
					246425,	--	Demo - CRUK 30 - 39
					246426,	--	Demo - CRUK 40 - 46
					246427,	--	Demo - GOSH 00 - 09
					246428,	--	Demo - GOSH 10 - 19
					246429,	--	Demo - GOSH 20 - 29
					246430,	--	Demo - GOSH 30 - 39
					246431,	--	DEMO - GOSH 40 - 46
					187786,	--	Demo Charity 1
					187790,	--	demo charity 2
					2050,	--	The Demo Charity
					181833	--	Demo Non Profit - Non beneficiary
				)
	), B AS
	(
		SELECT
			[# of Unique JTG Donors that Opted-In to JG Comms]	=	COUNT(DISTINCT DURN.Value)
		FROM
			BB01.dbo.BB01_SmsDonation SD
			INNER JOIN BB01.dbo.BB01_DonationLine DL ON SD.DonationLineId = DL.DonationLineId
			INNER JOIN BB01.dbo.BB01_Consumer C ON DL.ConsumerId = C.ConsumerId
			INNER JOIN BB01.dbo.BB01_ConsumerConsent CC ON C.ConsumerPortfolioId = CC.ConsumerPortfolioId
			INNER JOIN BB01.dbo.tblDURN DURN ON C.ConsumerId = DURN.ConsumerId
			INNER JOIN BB01.dbo.BB01_FundraiserRevenueStream FRS ON SD.FundraiserRevenueStreamId = FRS.FundraiserRevenueStreamId
			INNER JOIN BB01.dbo.tblFundraiserRevenueStreamMobile FRSM ON SD.FundraiserRevenueStreamId = FRSM.FundraiserRevenueStreamId
		WHERE
			DL.sysDateCreated < @BeginActWeek
			AND CC.FundraiserId = 0
			AND CC.AffiliateId = 1
			AND CC.CanContact = 1
			AND FRS.FundraiserId NOT IN
				(
					11318,	--	Oasis UK
					246422,	--	Demo - CRUK 00 - 09
					246423,	--	Demo - CRUK 10 - 19
					246424,	--	Demo - CRUK 20 - 29
					246425,	--	Demo - CRUK 30 - 39
					246426,	--	Demo - CRUK 40 - 46
					246427,	--	Demo - GOSH 00 - 09
					246428,	--	Demo - GOSH 10 - 19
					246429,	--	Demo - GOSH 20 - 29
					246430,	--	Demo - GOSH 30 - 39
					246431,	--	DEMO - GOSH 40 - 46
					187786,	--	Demo Charity 1
					187790,	--	demo charity 2
					2050,	--	The Demo Charity
					181833	--	Demo Non Profit - Non beneficiary
				)
	), C AS
	(
		SELECT
			[# of Unique JTG Donors that Opted-In to Charity Comms]	=	COUNT(DISTINCT DURN.Value)
		FROM
			BB01.dbo.BB01_SmsDonation SD
			INNER JOIN BB01.dbo.BB01_DonationLine DL ON SD.DonationLineId = DL.DonationLineId
			INNER JOIN BB01.dbo.BB01_Consumer C ON DL.ConsumerId = C.ConsumerId
			INNER JOIN BB01.dbo.BB01_ConsumerConsent CC ON C.ConsumerPortfolioId = CC.ConsumerPortfolioId
			INNER JOIN BB01.dbo.tblDURN DURN ON C.ConsumerId = DURN.ConsumerId
			INNER JOIN BB01.dbo.BB01_FundraiserRevenueStream FRS ON SD.FundraiserRevenueStreamId = FRS.FundraiserRevenueStreamId
			INNER JOIN BB01.dbo.tblFundraiserRevenueStreamMobile FRSM ON SD.FundraiserRevenueStreamId = FRSM.FundraiserRevenueStreamId
		WHERE
			DL.sysDateCreated < @BeginActWeek
			AND CC.FundraiserId <> 0
			AND CC.CanContact = 1
			AND FRS.FundraiserId NOT IN
				(
					11318,	--	Oasis UK
					246422,	--	Demo - CRUK 00 - 09
					246423,	--	Demo - CRUK 10 - 19
					246424,	--	Demo - CRUK 20 - 29
					246425,	--	Demo - CRUK 30 - 39
					246426,	--	Demo - CRUK 40 - 46
					246427,	--	Demo - GOSH 00 - 09
					246428,	--	Demo - GOSH 10 - 19
					246429,	--	Demo - GOSH 20 - 29
					246430,	--	Demo - GOSH 30 - 39
					246431,	--	DEMO - GOSH 40 - 46
					187786,	--	Demo Charity 1
					187790,	--	demo charity 2
					2050,	--	The Demo Charity
					181833	--	Demo Non Profit - Non beneficiary
				)
	), D AS
	(
		SELECT
			[# of JTG Donations with GA]	=	COUNT(DISTINCT DL.DonationLineId)
		FROM
			BB01.dbo.BB01_SmsDonation SD
			INNER JOIN BB01.dbo.BB01_DonationLine DL ON SD.DonationLineId = DL.DonationLineId
			INNER JOIN BB01.dbo.tblDURN DURN ON DL.ConsumerId = DURN.ConsumerId
			INNER JOIN BB01.dbo.BB01_FundraiserRevenueStream FRS ON SD.FundraiserRevenueStreamId = FRS.FundraiserRevenueStreamId
			INNER JOIN BB01.dbo.tblFundraiserRevenueStreamMobile FRSM ON SD.FundraiserRevenueStreamId = FRSM.FundraiserRevenueStreamId
		WHERE
			DL.sysDateCreated < @BeginActWeek
			AND DL.EstimatedTaxReclaim > 0
			AND FRS.FundraiserId NOT IN
				(
					11318,	--	Oasis UK
					246422,	--	Demo - CRUK 00 - 09
					246423,	--	Demo - CRUK 10 - 19
					246424,	--	Demo - CRUK 20 - 29
					246425,	--	Demo - CRUK 30 - 39
					246426,	--	Demo - CRUK 40 - 46
					246427,	--	Demo - GOSH 00 - 09
					246428,	--	Demo - GOSH 10 - 19
					246429,	--	Demo - GOSH 20 - 29
					246430,	--	Demo - GOSH 30 - 39
					246431,	--	DEMO - GOSH 40 - 46
					187786,	--	Demo Charity 1
					187790,	--	demo charity 2
					2050,	--	The Demo Charity
					181833	--	Demo Non Profit - Non beneficiary
				)
	), E AS
	(
		SELECT
			[# of JTG Donations]	=	COUNT(DISTINCT DL.DonationLineId)
		FROM
			BB01.dbo.BB01_SmsDonation SD
			INNER JOIN BB01.dbo.BB01_DonationLine DL ON SD.DonationLineId = DL.DonationLineId
			INNER JOIN BB01.dbo.tblDURN DURN ON DL.ConsumerId = DURN.ConsumerId
			INNER JOIN BB01.dbo.BB01_FundraiserRevenueStream FRS ON SD.FundraiserRevenueStreamId = FRS.FundraiserRevenueStreamId
			INNER JOIN BB01.dbo.tblFundraiserRevenueStreamMobile FRSM ON SD.FundraiserRevenueStreamId = FRSM.FundraiserRevenueStreamId
		WHERE
			DL.sysDateCreated < @BeginActWeek
			AND FRS.FundraiserId NOT IN
				(
					11318,	--	Oasis UK
					246422,	--	Demo - CRUK 00 - 09
					246423,	--	Demo - CRUK 10 - 19
					246424,	--	Demo - CRUK 20 - 29
					246425,	--	Demo - CRUK 30 - 39
					246426,	--	Demo - CRUK 40 - 46
					246427,	--	Demo - GOSH 00 - 09
					246428,	--	Demo - GOSH 10 - 19
					246429,	--	Demo - GOSH 20 - 29
					246430,	--	Demo - GOSH 30 - 39
					246431,	--	DEMO - GOSH 40 - 46
					187786,	--	Demo Charity 1
					187790,	--	demo charity 2
					2050,	--	The Demo Charity
					181833	--	Demo Non Profit - Non beneficiary
				)
	)
	INSERT INTO dbo.tblREPJTGDonors
	(
		[Date ID],
		[Date Name],
		[# of Unique JTG Donors],
		[# of Unique JTG Donors that Opted-In to JG Comms],
		[# of Unique JTG Donors that Opted-In to Charity Comms],
		[# of JTG Donations with GA],
		[# of JTG Donations]
	)
	SELECT
		[Date ID]													=	CONVERT(INT, CONVERT(VARCHAR, @EndPrevWeek, 112)),
		[Date Name]													=	'WE --> '+CONVERT(VARCHAR, @EndPrevWeek, 106),
		[# of Unique JTG Donors],
		[# of Unique JTG Donors that Opted-In to JG Comms],
		[# of Unique JTG Donors that Opted-In to Charity Comms],
		[# of JTG Donations with GA],
		[# of JTG Donations]
	FROM
		A,B,C,D,E;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT OFF;

GO


