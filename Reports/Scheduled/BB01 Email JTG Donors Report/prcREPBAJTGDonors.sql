USE JGReporting
GO

IF OBJECT_ID('dbo.prcREPBAJTGDonors') IS NOT NULL DROP PROCEDURE dbo.prcREPBAJTGDonors;
GO

CREATE PROCEDURE dbo.prcREPBAJTGDonors
AS

/**************************************************************************************
Procedure	:	prcREPBAJTGDonors
Category 	:	BB01 Email JTG Donors Report
Created By	:	Hem  based on Raul's Query
DateCreated	:	29/12/211
Modified	:	22/05/2012 (Raul Garcia). Modify the look of the script and place it in repository
				for future control source.
***************************************************************************************/

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT * FROM dbo.tblREPJTGDonors ORDER BY [Date ID] DESC;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET NOCOUNT OFF;

GO
--	EXEC prcREPBAJTGDonors




