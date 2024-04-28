ALTER PROCEDURE [dbo].[DemoInsertRowsInTable]

 

/*Parameters from Tableau*/
@InsertUserID NVARCHAR(4000)
,@InsertStartDate DATE
,@InsertEndDate DATE
,@InsertRun INT --New
,@InsertIncrementer INT --New

AS
BEGIN

/*Enable this to have less problems*/
SET NOCOUNT ON

/*Only Run the insert when Run=1*/
IF @InsertRun=1 --New

/*You need Begin here to separate your potential outcomes */
BEGIN

/*Insert data into table*/
INSERT INTO [DemoTable]
(
[UserID]
,[StartDate]
,[EndDatE]
)

VALUES
(
@InsertUserID           
,@InsertStartDate
,@InsertEndDate
)
;


/*Create a message to tell the end user what they have just done CHAR(13) is a Line Break*/
SELECT
CAST(CAST('You just added a new registration for' AS NVARCHAR(1000)) +CHAR(13)+ @InsertUserID +CHAR(13) +CAST(@InsertStartDate AS NVARCHAR(10))+CHAR(13)+ CAST(@InsertEndDate AS NVARCHAR(10))AS NVARCHAR(1000))
AS Result

/*You need to End your previous Begin*/
END
ELSE

/*Return empty string*/
SELECT
CAST('' AS NVARCHAR(1000)) AS Result --New
END




