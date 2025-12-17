USE [QueensClassSchedule]
GO

/**
Group 4 10:45 section

Memebers: Sayantan Saha, Fahim Tanvir, Esfar Rakin, Yousuf Ahmed, Justin Zara

PLEASE RUN THEM NOT , I REPEAT NOT ALL AT ONCE. RUN THEM BY EACH STEP. All of us had errors running them all at once. 

**/


--Step 1: It aint here(ER diagram was step 1)

--Step 2: Make our schemas so we know where our data goes.
CREATE SCHEMA [DbSecurity] AUTHORIZATION [dbo];
GO
CREATE SCHEMA [Process] AUTHORIZATION [dbo];
GO
CREATE SCHEMA [Udt] AUTHORIZATION [dbo];
GO
CREATE SCHEMA [Data] AUTHORIZATION [dbo];
GO

--Step 3: Make Our udts so we can make our tables and data types easier(NOTE: WE INCREASTED size of our types by 10 bytes to prevent truncation errors)
CREATE TYPE [Udt].[SurrogateKeyInt] FROM [INT] NOT NULL;
GO
CREATE TYPE [Udt].[CodeVarchar10] FROM [VARCHAR](30) NOT NULL; 
GO
CREATE TYPE [Udt].[NameVarchar50] FROM [VARCHAR](50) NULL;
GO
CREATE TYPE [Udt].[AtomicNameVarchar30] FROM [VARCHAR](50) NOT NULL; 
GO
CREATE TYPE [Udt].[AddressVarchar50] FROM [VARCHAR](50) NULL;
GO
CREATE TYPE [Udt].[DescriptionVarchar100] FROM [VARCHAR](100) NOT NULL;
GO
CREATE TYPE [Udt].[DayVarchar20] FROM [VARCHAR](20) NOT NULL;
GO
CREATE TYPE [Udt].[CountInt] FROM [INT] NOT NULL;
GO
CREATE TYPE [Udt].[TimeType] FROM [TIME](7) NOT NULL;
GO
CREATE TYPE [Udt].[DateTimeAudit] FROM [DATETIME2](7) NOT NULL;
GO
CREATE TYPE [Udt].[AuthorizationKey] FROM [INT] NOT NULL;
GO



--Step 4: Making our tables based on the diagram from Step 1

-- [Data].[BuildingLocation]
CREATE TABLE [Data].[BuildingLocation](
[BuildingKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[BuildingDesignation] [Udt].[CodeVarchar10],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_BuildingLocation_BuildingKey] PRIMARY KEY CLUSTERED ([BuildingKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[Department]
CREATE TABLE [Data].[Department](
[DepartmentKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[DepartmentDesignation] [Udt].[CodeVarchar10],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_Department_DepartmentKey] PRIMARY KEY CLUSTERED ([DepartmentKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[Instructor]
CREATE TABLE [Data].[Instructor](
[InstructorKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[InstructorFirstName] [Udt].[AtomicNameVarchar30],
[InstructorLastName] [Udt].[AtomicNameVarchar30],
[InstructorFullName] AS (CONCAT([InstructorLastName], ', ', [InstructorFirstName])) PERSISTED, 
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_Instructor_InstructorKey] PRIMARY KEY NONCLUSTERED ([InstructorKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[Mode]
CREATE TABLE [Data].[Mode](
[ModeKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[ModeDescription] [Udt].[CodeVarchar10],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_Mode_ModeKey] PRIMARY KEY CLUSTERED ([ModeKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[RoomLocation]
CREATE TABLE [Data].[RoomLocation](
[BuildingKey] [Udt].[SurrogateKeyInt] NOT NULL,
[RoomKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[RoomNumber] [Udt].[CodeVarchar10],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_RoomLocation_RoomKey] PRIMARY KEY CLUSTERED ([RoomKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[Course]
CREATE TABLE [Data].[Course](
[DepartmentKey] [Udt].[SurrogateKeyInt] NOT NULL,
[CourseKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[CourseName] [Udt].[CodeVarchar10],
[CourseDescription] [Udt].[DescriptionVarchar100],
[CourseCredit] [Udt].[CodeVarchar10],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_Course_CourseKey] PRIMARY KEY CLUSTERED ([CourseKey] ASC),
CONSTRAINT [UC_Course_DepartmentKey_CourseName] UNIQUE ([DepartmentKey], [CourseName])
) ON [PRIMARY]
GO

-- [Data].[DepartmentInstructor] 
CREATE TABLE [Data].[DepartmentInstructor](
[InstructorKey] [Udt].[SurrogateKeyInt] NOT NULL,
[DepartmentKey] [Udt].[SurrogateKeyInt] NOT NULL,
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_DepartmentInstructor_Keys] PRIMARY KEY CLUSTERED ([InstructorKey] ASC, [DepartmentKey] ASC)
) ON [PRIMARY]
GO

-- [Data].[Section] 
CREATE TABLE [Data].[Section](
[DepartmentKey] [Udt].[SurrogateKeyInt] NOT NULL,
[CourseKey] [Udt].[SurrogateKeyInt] NOT NULL,
[InstructorKey] [Udt].[SurrogateKeyInt] NOT NULL,
[SectionCode] [Udt].[CountInt],
[SectionKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[BuildingKey] [Udt].[SurrogateKeyInt] NOT NULL,
[RoomKey] [Udt].[SurrogateKeyInt] NOT NULL,
[CourseName] [Udt].[CodeVarchar10],
[SectionNumber] [Udt].[CodeVarchar10],
[SectionDay] [Udt].[DayVarchar20],
[StartTime] [Udt].[TimeType],
[EndTime] [Udt].[TimeType],
[HourCount] [Udt].[CountInt],
[ModeKey] [Udt].[SurrogateKeyInt] NOT NULL,
[EnrolledCount] [Udt].[CountInt],
[LimitCount] [Udt].[CountInt],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[AuthorizedUserKey] [Udt].[AuthorizationKey],
CONSTRAINT [PK_Section_SectionKey] PRIMARY KEY CLUSTERED ([SectionKey] ASC),
-- This constraint caused us to have errors  so we used ROW_NUMBER() 
CONSTRAINT [UC_Section_BusinessKey] UNIQUE NONCLUSTERED (
[DepartmentKey], [CourseKey], [InstructorKey], [BuildingKey], [RoomKey], [SectionCode])
) ON [PRIMARY]
GO

-- [DbSecurity].[UserAuthorization]
CREATE TABLE [DbSecurity].[UserAuthorization](
[UserAuthorizationKey] [Udt].[AuthorizationKey] IDENTITY(1,1) NOT NULL, 
[ProjectName] [Udt].[NameVarchar50] DEFAULT ('PROJECT 3: QueensClassSchedule DB RECONSTRUCTION '), 
[AuditorLastName] [Udt].[AtomicNameVarchar30],
[AuditorFirstName] [Udt].[AtomicNameVarchar30],
[DateAdded] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[DateLastUpdated] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
PRIMARY KEY CLUSTERED ([UserAuthorizationKey] ASC)
) ON [PRIMARY]
GO

-- [Process].[WorkflowSteps] 
CREATE TABLE [Process].[WorkflowSteps](
[WorkFlowStepKey] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
[WorkFlowStepDescription] [Udt].[DescriptionVarchar100],
[WorkFlowStepTableRowCount] [Udt].[CountInt] DEFAULT ((0)),
[StartingDateTime] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[EndingDateTime] [Udt].[DateTimeAudit] DEFAULT (sysdatetime()),
[ClassTime] CHAR(5) NULL DEFAULT ('10:45'),
[UserAuthorizationKey] [Udt].[AuthorizationKey] NOT NULL,
[GroupMemberLastName] [Udt].[AtomicNameVarchar30] DEFAULT ('Your last name'),
[GroupMemberFirstName] [Udt].[AtomicNameVarchar30] DEFAULT ('Your first name'),
PRIMARY KEY CLUSTERED ([WorkFlowStepKey] ASC)
) ON [PRIMARY]
GO

---THIS WILL LEAD US FROM STEP 4 TO STEP 5:
--STEP 5a  we will create procedures
-- [Process].[ShowWorkflowSteps]
CREATE PROCEDURE [Process].[ShowWorkflowSteps]
AS
BEGIN
  SELECT *
  FROM Process.WorkflowSteps
  SELECT CONCAT(SUM(B.time_elapsed), ' MILLISECONDS') AS TotalTimeElapsed
  FROM
  (SELECT time_elapsed = DATEDIFF(MILLISECOND, A.StartingDateTime, A.EndingDateTime)
  FROM Process.WorkflowSteps AS A) AS B
END;
GO

-- [Process].[TrackWorkFlow]
CREATE PROCEDURE [Process].[TrackWorkFlow]
  @WorkFlowDescription [Udt].[DescriptionVarchar100],
  @WorkFlowStepTableRowCount [Udt].[CountInt],
  @UserAuthorizationKey [Udt].[AuthorizationKey],
  @StartTime [Udt].[DateTimeAudit],
  @EndTime [Udt].[DateTimeAudit]
AS
BEGIN
  INSERT INTO Process.WorkflowSteps
  (WorkFlowStepDescription, WorkFlowStepTableRowCount, UserAuthorizationKey, StartingDateTime, EndingDateTime, GroupMemberLastName, GroupMemberFirstName)
  VALUES
  (@WorkFlowDescription, @WorkFlowStepTableRowCount, @UserAuthorizationKey, @StartTime, @EndTime,
  (SELECT AuditorLastName FROM DbSecurity.UserAuthorization WHERE UserAuthorizationKey = @UserAuthorizationKey),
  (SELECT AuditorFirstName FROM DbSecurity.UserAuthorization WHERE UserAuthorizationKey = @UserAuthorizationKey));
END;
GO

-- [Data].[AddForeignKeys]
CREATE PROCEDURE [Data].[AddForeignKeys]
@AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
ALTER TABLE [Data].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Instructor] FOREIGN KEY ([InstructorKey]) REFERENCES [Data].[Instructor]([InstructorKey]) ON DELETE CASCADE
ALTER TABLE [Data].[Section] CHECK CONSTRAINT [FK_Section_Instructor]

ALTER TABLE [Data].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Mode] FOREIGN KEY ([ModeKey]) REFERENCES [Data].[Mode]([ModeKey]) ON DELETE CASCADE
ALTER TABLE [Data].[Section] CHECK CONSTRAINT [FK_Section_Mode]

ALTER TABLE [Data].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_Course] FOREIGN KEY ([CourseKey]) REFERENCES [Data].[Course]([CourseKey]) ON DELETE CASCADE
ALTER TABLE [Data].[Section] CHECK CONSTRAINT [FK_Section_Course]

ALTER TABLE [Data].[Section] WITH CHECK ADD CONSTRAINT [FK_Section_RoomLocation] FOREIGN KEY ([RoomKey]) REFERENCES [Data].[RoomLocation]([RoomKey]) ON DELETE CASCADE
ALTER TABLE [Data].[Section] CHECK CONSTRAINT [FK_Section_RoomLocation]

ALTER TABLE [Data].[Course] WITH CHECK ADD CONSTRAINT [FK_Course_Department] FOREIGN KEY([DepartmentKey]) REFERENCES [Data].[Department] ([DepartmentKey]) ON DELETE CASCADE
ALTER TABLE [Data].[Course] CHECK CONSTRAINT [FK_Course_Department]

ALTER TABLE [Data].[DepartmentInstructor] WITH CHECK ADD CONSTRAINT [FK_DI_Department] FOREIGN KEY([DepartmentKey]) REFERENCES [Data].[Department] ([DepartmentKey]) ON DELETE CASCADE
ALTER TABLE [Data].[DepartmentInstructor] CHECK CONSTRAINT [FK_DI_Department]

ALTER TABLE [Data].[DepartmentInstructor] WITH CHECK ADD CONSTRAINT [FK_DI_Instructor] FOREIGN KEY([InstructorKey]) REFERENCES [Data].[Instructor] ([InstructorKey]) ON DELETE CASCADE
ALTER TABLE [Data].[DepartmentInstructor] CHECK CONSTRAINT [FK_DI_Instructor]

ALTER TABLE [Data].[RoomLocation] WITH CHECK ADD CONSTRAINT [FK_RoomLocation_BuildingLocation] FOREIGN KEY([BuildingKey]) REFERENCES [Data].[BuildingLocation] ([BuildingKey]) ON DELETE CASCADE
ALTER TABLE [Data].[RoomLocation] CHECK CONSTRAINT [FK_RoomLocation_BuildingLocation]

END;
GO


-- [Data].[DropForeignKeys]
CREATE PROCEDURE [Data].[DropForeignKeys]
@AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
ALTER TABLE [Data].Section DROP CONSTRAINT IF EXISTS FK_Section_Instructor;
ALTER TABLE [Data].Section DROP CONSTRAINT IF EXISTS FK_Section_Mode;
ALTER TABLE [Data].Section DROP CONSTRAINT IF EXISTS FK_Section_Course;
ALTER TABLE [Data].Section DROP CONSTRAINT IF EXISTS FK_Section_RoomLocation;
ALTER TABLE [Data].Course DROP CONSTRAINT IF EXISTS FK_Course_Department;
ALTER TABLE [Data].DepartmentInstructor DROP CONSTRAINT IF EXISTS FK_DI_Department;
ALTER TABLE [Data].DepartmentInstructor DROP CONSTRAINT IF EXISTS FK_DI_Instructor;
ALTER TABLE [Data].RoomLocation DROP CONSTRAINT IF EXISTS FK_RoomLocation_BuildingLocation;
END;
GO


-- [Data].[LoadBuildingLocation]
CREATE PROCEDURE [Data].[LoadBuildingLocation]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME()

  INSERT INTO [Data].BuildingLocation (BuildingDesignation, AuthorizedUserKey)
  SELECT DISTINCT
  REPLACE(LEFT([Location], CHARINDEX(' ', [Location])), ' ', ''),
  @AuthorizedUserKey
  FROM Uploadfile.CurrentSemesterCourseOfferings;

UPDATE [Data].BuildingLocation
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].BuildingLocation);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate BuildingLocation Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadDepartment]
CREATE PROCEDURE [Data].[LoadDepartment]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME();

    WITH CleanedSource AS (
        SELECT 
            CleanCourseHrCrd = LTRIM(RTRIM(REPLACE(REPLACE([Course (hr, crd)], CHAR(13), ''), CHAR(10), '')))
        FROM Uploadfile.CurrentSemesterCourseOfferings
    ),
    ParsedSource AS (
        SELECT 
            DeptDesignationRaw = CASE
                                WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                ELSE CleanCourseHrCrd
                             END
        FROM CleanedSource
        WHERE CleanCourseHrCrd IS NOT NULL AND CleanCourseHrCrd <> ''
    )
  INSERT INTO [Data].Department (DepartmentDesignation, AuthorizedUserKey)
  SELECT DISTINCT
    RTRIM(DeptDesignationRaw)
  , @AuthorizedUserKey
  FROM ParsedSource
  WHERE RTRIM(DeptDesignationRaw) IS NOT NULL AND RTRIM(DeptDesignationRaw) <> '';

UPDATE [Data].Department
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].Department);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate Department Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadInstructor]
CREATE PROCEDURE [Data].[LoadInstructor]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME()

  INSERT INTO [Data].Instructor (InstructorFirstName, InstructorLastName, AuthorizedUserKey)
  SELECT DISTINCT
  LTRIM(RTRIM(RIGHT(Instructor, LEN(Instructor)-CHARINDEX(',', Instructor)))) AS InstructorFirstName,
  LTRIM(RTRIM(LEFT(Instructor, CHARINDEX(',', Instructor)-1))) AS InstructorLastName,
  @AuthorizedUserKey
  FROM Uploadfile.CurrentSemesterCourseOfferings
WHERE Instructor IS NOT NULL AND CHARINDEX(',', Instructor) > 0;

UPDATE [Data].Instructor
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].Instructor);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate Instructor Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadMode]
CREATE PROCEDURE [Data].[LoadMode]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME()

  INSERT INTO [Data].Mode (ModeDescription, AuthorizedUserKey)
  SELECT DISTINCT
  [Mode of Instruction],
  @AuthorizedUserKey
  FROM Uploadfile.CurrentSemesterCourseOfferings
WHERE [Mode of Instruction] IS NOT NULL;

UPDATE [Data].Mode
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].Mode);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate Mode Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadRoomLocation]
CREATE PROCEDURE [Data].[LoadRoomLocation]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME()

  INSERT INTO [Data].RoomLocation (BuildingKey, RoomNumber, AuthorizedUserKey)
  SELECT DISTINCT
  BL.BuildingKey,
  REPLACE(RIGHT([Location], LEN([Location]) - CHARINDEX(' ', [Location])), ' ', ''),
  @AuthorizedUserKey
  FROM Uploadfile.CurrentSemesterCourseOfferings AS CSCO
  LEFT JOIN [Data].BuildingLocation AS BL
ON REPLACE(LEFT(CSCO.[Location], CHARINDEX(' ', CSCO.[Location])), ' ', '') = BL.BuildingDesignation
WHERE BL.BuildingKey IS NOT NULL AND CSCO.[Location] IS NOT NULL;

UPDATE [Data].RoomLocation
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].RoomLocation);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate RoomLocation Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadCourse]
CREATE PROCEDURE [Data].[LoadCourse]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME();

    WITH CleanedSource AS (
        SELECT 
            *,
            CleanCourseHrCrd = LTRIM(RTRIM(REPLACE(REPLACE([Course (hr, crd)], CHAR(13), ''), CHAR(10), '')))
        FROM Uploadfile.CurrentSemesterCourseOfferings
    ),
    ParsedSource AS (
        SELECT 
            *,
            DeptDesignationRaw = CASE 
                                WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                ELSE CleanCourseHrCrd
                             END,
            CourseNameRaw = LTRIM(RTRIM(
                            SUBSTRING(
                                CleanCourseHrCrd, 
                                LEN(CASE 
                                        WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                        THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                        ELSE CleanCourseHrCrd
                                    END) + 1, 
                                CHARINDEX('(', CleanCourseHrCrd) - LEN(CASE 
                                                                        WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                                                        THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                                                        ELSE CleanCourseHrCrd
                                                                    END) - 1
                            )))
        FROM CleanedSource
        WHERE CHARINDEX('(', CleanCourseHrCrd) > 0
          AND PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0
    )
  INSERT INTO [Data].Course (DepartmentKey, CourseDescription, CourseName, CourseCredit, AuthorizedUserKey)
  SELECT DISTINCT
  D.DepartmentKey,
  PS.[Description],
  PS.CourseNameRaw AS CourseName, 
  LTRIM(RTRIM(
    REPLACE(
      REPLACE(
        SUBSTRING(
          PS.CleanCourseHrCrd, 
          CHARINDEX('crd', PS.CleanCourseHrCrd) - 2, 
          2 
        ), 
        ',', ''
      ), 
      ' ', ''
    )
  )) AS CourseCredit,
  @AuthorizedUserKey
  FROM ParsedSource AS PS
  LEFT JOIN [Data].Department AS D
    ON RTRIM(PS.DeptDesignationRaw) = D.DepartmentDesignation
WHERE D.DepartmentKey IS NOT NULL
  AND PS.CourseNameRaw IS NOT NULL;

UPDATE [Data].[Course]
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].Course);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate Course Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- [Data].[LoadDepartmentInstructor] 
CREATE PROCEDURE [Data].[LoadDepartmentInstructor] 
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME(); 

    WITH CleanedSource AS (
        SELECT 
            *,
            CleanCourseHrCrd = LTRIM(RTRIM(REPLACE(REPLACE([Course (hr, crd)], CHAR(13), ''), CHAR(10), '')))
        FROM Uploadfile.CurrentSemesterCourseOfferings
    ),
    ParsedSource AS (
        SELECT 
            *,
            DeptDesignation = RTRIM(CASE 
                                WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                ELSE CleanCourseHrCrd
                             END)
        FROM CleanedSource
        WHERE CleanCourseHrCrd IS NOT NULL AND CleanCourseHrCrd <> ''
    )
  INSERT INTO [Data].DepartmentInstructor (InstructorKey, DepartmentKey, AuthorizedUserKey)
  SELECT DISTINCT
  I.InstructorKey,
  D.DepartmentKey,
  @AuthorizedUserKey
  FROM ParsedSource AS PS
  LEFT JOIN [Data].Department AS D
    ON PS.DeptDesignation = D.DepartmentDesignation 
  LEFT JOIN [Data].Instructor AS I
ON (LTRIM(RTRIM(RIGHT(PS.Instructor, LEN(PS.Instructor)-CHARINDEX(',', PS.Instructor)))) = I.InstructorFirstName 
AND LTRIM(RTRIM(LEFT(PS.Instructor, CHARINDEX(',', PS.Instructor)-1))) = I.InstructorLastName)
WHERE D.DepartmentKey IS NOT NULL AND I.InstructorKey IS NOT NULL;

UPDATE [Data].DepartmentInstructor 
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].DepartmentInstructor); 
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate DepartmentInstructor Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


-- Step 5b: Stored Procedure we get  and Load Procedure we shall(so the data in Uploadfile table ends up in the tables we just made)
CREATE PROCEDURE [Data].[LoadSection]
  @AuthorizedUserKey [Udt].[AuthorizationKey]
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StartDateTime AS [Udt].[DateTimeAudit], @EndDateTime AS [Udt].[DateTimeAudit];
  SET @StartDateTime = SYSDATETIME(); 

    WITH CleanedSource AS (
        SELECT 
            *,
            CleanCourseHrCrd = LTRIM(RTRIM(REPLACE(REPLACE([Course (hr, crd)], CHAR(13), ''), CHAR(10), '')))
        FROM Uploadfile.CurrentSemesterCourseOfferings
    ),
    ParsedSource AS (
        SELECT 
            *,
            DeptDesignationRaw = CASE
                                WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                ELSE CleanCourseHrCrd
                             END,
            CourseNameRaw = LTRIM(RTRIM(
                            SUBSTRING(
                                CleanCourseHrCrd, 
                                LEN(CASE 
                                        WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                        THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                        ELSE CleanCourseHrCrd
                                    END) + 1, 
                                CHARINDEX('(', CleanCourseHrCrd) - LEN(CASE 
                                                                        WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                                                        THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                                                        ELSE CleanCourseHrCrd
                                                                    END) - 1
                            ))),
             DeptDesignation = RTRIM(CASE 
                                WHEN PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0 
                                THEN SUBSTRING(CleanCourseHrCrd, 1, PATINDEX('%[0-9]%', CleanCourseHrCrd) - 1)
                                ELSE CleanCourseHrCrd
                             END),
			 BuildingDesignation = REPLACE(LEFT([Location], CHARINDEX(' ', [Location])), ' ', ''),
			 RoomNumber = REPLACE(RIGHT([Location], LEN([Location]) - CHARINDEX(' ', [Location])), ' ', '')
        FROM CleanedSource
        WHERE CHARINDEX('(', CleanCourseHrCrd) > 0 
          AND PATINDEX('%[0-9]%', CleanCourseHrCrd) > 0
    ),
	DeDupedSource AS (
		SELECT
			PS.*,
			D.DepartmentKey,
			C.CourseKey,
			I.InstructorKey,
			BL.BuildingKey,
			RL.RoomKey,
			M.ModeKey,
			StartTime = CAST(REPLACE(LEFT(PS.[Time], CHARINDEX('-', PS.[Time])), '-', '') AS TIME(7)),
			EndTime = CAST(REPLACE(RIGHT(PS.[Time], LEN(PS.[Time]) - CHARINDEX('-', PS.[Time])), ' ', '') AS TIME(7)),
			HourCount = CAST(SUBSTRING(PS.CleanCourseHrCrd, CHARINDEX(')', PS.CleanCourseHrCrd)-1, 1) AS INT),
			
			-- De-duplication Logic: Only keep the first instance of a duplicate business key
			RowNumber = ROW_NUMBER() OVER (
				PARTITION BY D.DepartmentKey, C.CourseKey, I.InstructorKey, BL.BuildingKey, RL.RoomKey, PS.Code
				ORDER BY PS.Code 
			)
		FROM ParsedSource AS PS
		LEFT JOIN [Data].Department AS D
		ON PS.DeptDesignation = D.DepartmentDesignation 
		LEFT JOIN [Data].Instructor AS I 
		ON (LTRIM(RTRIM(RIGHT(PS.Instructor, LEN(PS.Instructor)-CHARINDEX(',', PS.Instructor)))) = I.InstructorFirstName 
		AND LTRIM(RTRIM(LEFT(PS.Instructor, CHARINDEX(',', PS.Instructor)-1))) = I.InstructorLastName)
		LEFT JOIN [Data].BuildingLocation AS BL
		ON PS.BuildingDesignation = BL.BuildingDesignation 
		LEFT JOIN [Data].RoomLocation AS RL
		ON BL.BuildingKey = RL.BuildingKey 
		AND PS.RoomNumber = RL.RoomNumber
		LEFT JOIN [Data].Mode AS M
		ON M.ModeDescription = PS.[Mode of Instruction]
		LEFT JOIN [Data].Course AS C
		ON PS.CourseNameRaw = C.CourseName
		AND D.DepartmentKey = C.DepartmentKey 
		
		WHERE D.DepartmentKey IS NOT NULL 
		AND C.CourseKey IS NOT NULL 
		AND I.InstructorKey IS NOT NULL 
		AND BL.BuildingKey IS NOT NULL 
		AND RL.RoomKey IS NOT NULL
		AND M.ModeKey IS NOT NULL
	)
	
  INSERT INTO [Data].Section
  ([DepartmentKey], SectionCode, CourseKey, InstructorKey, BuildingKey, RoomKey,
  SectionDay, [StartTime], [EndTime], [HourCount], EnrolledCount, LimitCount, ModeKey, SectionNumber,
  CourseName, AuthorizedUserKey)
  SELECT
  DepartmentKey, Code, CourseKey, InstructorKey, BuildingKey, RoomKey, 
  [Day], StartTime, EndTime, HourCount, enrolled, [limit], ModeKey, Sec, CourseNameRaw,
  @AuthorizedUserKey
  FROM DeDupedSource 
  WHERE RowNumber = 1;


UPDATE [Data].Section
SET [DateLastUpdated] = SYSDATETIME()
WHERE [AuthorizedUserKey] = @AuthorizedUserKey;

  DECLARE @RowCount AS INT = (SELECT COUNT(*) FROM [Data].Section);
  SET @EndDateTime = SYSDATETIME();

  EXEC [Process].[TrackWorkFlow]
  @WorkFlowDescription = 'Populate Section Table',
  @WorkFlowStepTableRowCount = @RowCount,
  @UserAuthorizationKey = @AuthorizedUserKey,
  @StartTime = @StartDateTime, @EndTime = @EndDateTime
END;
GO


--LAST STEP is to just authorize the auditor. We had an idea to also release the name of the person looking at the courses, but gave up halfway
INSERT INTO [DbSecurity].[UserAuthorization]
           ([AuditorLastName]
           ,[AuditorFirstName]
           )
     VALUES
           ('FahimEsfarJustinYousufSayantan'
           ,'Johnson'
           )

USE [QueensClassSchedule]
GO


DECLARE @UserAuthKeyLoad [Udt].[AuthorizationKey];
-- Fetch the UserAuthorizationKey based on the name inserted in the setup script
SELECT @UserAuthKeyLoad = UserAuthorizationKey
FROM [DbSecurity].[UserAuthorization]
WHERE AuditorLastName = 'FahimEsfarJustinYousufSayantan'
  AND AuditorFirstName = 'Johnson';

-- Check if the key was found (essential for procedure execution)
IF @UserAuthKeyLoad IS NULL
BEGIN
    PRINT 'Error: User Authorization Key not found. Please ensure the user record exists in DbSecurity.UserAuthorization.';
    RETURN;
END
ELSE
BEGIN
    PRINT CONCAT('User Authorization Key retrieved: ', @UserAuthKeyLoad);
END
GO

--Exec our ETL workflow
DECLARE @UserAuthKeyLoad [Udt].[AuthorizationKey];
SELECT @UserAuthKeyLoad = UserAuthorizationKey FROM [DbSecurity].[UserAuthorization] WHERE AuditorLastName = 'FahimEsfarJustinYousufSayantan' AND AuditorFirstName = 'Johnson';

PRINT 'Starting ETL process...';

-- 1. Drop existing Foreign Keys 
EXEC [Data].[DropForeignKeys] @AuthorizedUserKey = @UserAuthKeyLoad;

-- 2. Load Dimension Tables
EXEC [Data].[LoadBuildingLocation] @AuthorizedUserKey = @UserAuthKeyLoad;
EXEC [Data].[LoadDepartment] @AuthorizedUserKey = @UserAuthKeyLoad;
EXEC [Data].[LoadInstructor] @AuthorizedUserKey = @UserAuthKeyLoad; -- Table name is Instructor
EXEC [Data].[LoadMode] @AuthorizedUserKey = @UserAuthKeyLoad;
EXEC [Data].[LoadRoomLocation] @AuthorizedUserKey = @UserAuthKeyLoad;
EXEC [Data].[LoadCourse] @AuthorizedUserKey = @UserAuthKeyLoad; 
EXEC [Data].[LoadDepartmentInstructor] @AuthorizedUserKey = @UserAuthKeyLoad;  -- Renamed from LoadInstructorDepartment

-- 3. Load Fact Table (Section)
EXEC [Data].[LoadSection] @AuthorizedUserKey = @UserAuthKeyLoad; 

-- 4. Add Foreign Keys back
EXEC [Data].[AddForeignKeys] @AuthorizedUserKey = @UserAuthKeyLoad;

PRINT 'ETL process completed. Displaying results.';
GO

--View and populate our tables

SELECT '--- Source Data (Uploadfile.CurrentSemesterCourseOfferings) ---' as TableHeader, * FROM Uploadfile.CurrentSemesterCourseOfferings;
SELECT '--- BuildingLocation Data ---' as TableHeader, * FROM Data.BuildingLocation;
SELECT '--- Department Data ---' as TableHeader, * FROM Data.Department;
SELECT '--- Instructor Data ---' as TableHeader, * FROM Data.Instructor; -- Table name is Instructor
SELECT '--- Mode Data ---' as TableHeader, * FROM Data.Mode;
SELECT '--- RoomLocation Data ---' as TableHeader, * FROM Data.RoomLocation;
SELECT '--- Course Data ---' as TableHeader, * FROM Data.Course;
SELECT '--- DepartmentInstructor Data ---' as TableHeader, * FROM Data.DepartmentInstructor; -- Renamed from InstructorDepartment
SELECT '--- Section Data (Fact Table) ---' as TableHeader, * FROM Data.Section;
SELECT '--- UserAuthorization Data ---' as TableHeader, * FROM DbSecurity.UserAuthorization;

-- View the ETL workflow history and total runtime
EXEC [Process].[ShowWorkflowSteps];
GO

--and we are done