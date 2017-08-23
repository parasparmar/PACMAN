USE [CWFM_Umang]
GO
/****** Object:  Schema [WFMP]    Script Date: 8/24/2017 2:55:04 AM ******/
CREATE SCHEMA [WFMP]
GO
/****** Object:  StoredProcedure [WFMP].[CE]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [WFMP].[CE]
(
	@XEMP AS INT,  
	@FNAME AS VARCHAR(20) = NULL  
)
AS  
DECLARE @XSTR AS VARCHAR(1000)  
IF ISNULL(@FNAME,'') = ''  
BEGIN  
	SELECT * FROM [WFMP].[TBLMASTER] WHERE EMPCODE = @XEMP  
END  
ELSE  
BEGIN  
	SET @XSTR = 'SELECT * FROM [WFMP].[TBLMASTER] WHERE (FNAME+'' ''+MNAME+'' ''+LNAME LIKE ''' + @FNAME + '%'') OR (NTNAME LIKE ''%' + @FNAME + '%'') ORDER BY FNAME,MNAME,LNAME'  
	--PRINT @XSTR
	EXECUTE(@XSTR)  
END
GO
/****** Object:  StoredProcedure [WFMP].[getEmployeeData]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		paras.parmar@sitel.com
-- Create date: 04-Aug-2017 1.59 AM
-- Description:	This stored procedure gets the specific row of the employee for the Team Anatomy profile page.
-- Modification date : 23-08-2017 12.51 AM
-- The table cwfm_umang..WFM_Employee_List was broken up into several tables at Gurdeeps request. 2
-- such are WFMP.tblMaster & WFMP.tblProfile which form the basis for this procedure.
-- =============================================
CREATE PROCEDURE [WFMP].[getEmployeeData] 
	-- Add the parameters for the stored procedure here
	@NT_ID varchar(50)  
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	----Select top 1 * from cwfm_umang..WFM_Employee_List where NT_ID = @NT_ID
	select top 1
	A.Employee_ID, A.First_Name, A.Middle_Name, A.Last_Name, C.Designation as DesignationID
	, D.Level as LevelID, A.DOJ, A.DOP, A.DOR, A.DPT, A.DOPS, E.EmpStatus, H.TrngStatus
	, I.Type as Job_Type, J.Country as CountryID, K.Site as SiteID, L.[Function] as FunctionId, M.LOB as LOBID, F.SkillSet
	, G.SubSkillSet, A.RepMgrCode, A.TeamID, A.ntName, A.ResType
	, A.BusinessID, A.Employee_ID, B.Date_of_Birth, B.Gender, A.Email_Office
	, B.Email_Personal, B.Contact_Number, B.AnniversaryDate, B.HighestQualification
	, B.Transport, B.Address1, B.Address2, B.Landmark, B.City, B.Total_Work_Experience
	, B.Skill1, B.Skill2, B.Skill3, B.Alternate_Contact, B.EmergencyContactPerson
	, B.UserImage, B.Updated_by, B.Update_Date
	from WFMP.tblMaster A inner join WFMP.tblProfile B on B.Employee_ID = A.Employee_ID
	left join WFMP.tblDesignation C on C.TransID = A.DesignationID
	left join WFMP.tblLevel D on D.TransID = A.LevelID
	left join WFMP.tblEmpStatus E on E.Id = A.EmpStatus
	left join WFMP.tblSkillSet F on F.TransID = A.SkillSet
	left join WFMP.tblSubSkillSet G on G.TransID = A.SubSkillSet
	left join WFMP.tblTrainingStatus H on H.TransID = A.TrngStatus
	left join WFMP.tblJob_Type I on I.Id = A.Job_Type
	left join WFMP.tblCountry J on J.TransID = A.CountryID
	left join WFMP.tblSite K on K.TransID = A.SiteID
	left join WFMP.tblFunction L on L.TransID = A.FunctionId
	left join WFMP.tblLOB M on M.TransID = A.LOBID
	where ntName = @NT_ID
END

GO
/****** Object:  StoredProcedure [WFMP].[updateEmployeeProfileData]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Paras Parmar
-- Create date: 05-August-2017 12.35 AM
-- Description:	Updates the entries for an employee in the Team Anatomy Profile page
-- =============================================
CREATE PROCEDURE [WFMP].[updateEmployeeProfileData] 
		@Employee_ID int,
		@Date_of_Birth datetime,
		@Gender varchar(10),		
		@Email_Personal varchar(255),
		@Contact_Number bigint,
		@AnniversaryDate datetime,
		@HighestQualification varchar(255),
		@Transport bit,
		@Address1 varchar(255),
		@Address2 varchar(255),
		@Landmark varchar(255),
		@City varchar(255),
		@Total_Work_Experience int,
		@Skill1 varchar(255),
		@Skill2 varchar(255),
		@Skill3 varchar(255),
		@Alternate_Contact bigint,
		@EmergencyContactPerson varchar(255),		
		@Updated_by nvarchar(50),
		@Update_Date datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



 Update [CWFM_Umang].[WFMP].[tblProfile]
 Set	Date_of_Birth = @Date_of_Birth, 
		Gender = @Gender, 		 
		Email_Personal = @Email_Personal, 
		Contact_Number = @Contact_Number, 
		AnniversaryDate = @AnniversaryDate, 
		HighestQualification = @HighestQualification, 
		Transport = @Transport, 
		Address1 = @Address1, 
		Address2 = @Address2, 
		Landmark = @Landmark, 
		City = @City, 
		Total_Work_Experience = @Total_Work_Experience, 
		Skill1 = @Skill1, 
		Skill2 = @Skill2, 
		Skill3 = @Skill3, 
		Alternate_Contact = @Alternate_Contact, 
		EmergencyContactPerson = @EmergencyContactPerson, 		
		Updated_by = @Updated_by, 
		Update_Date = @Update_Date
where Employee_ID = @Employee_ID

END

GO
/****** Object:  Table [WFMP].[tblAccount]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblAccount](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Account] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblCountry]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblCountry](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[Capital] [varchar](50) NOT NULL,
	[Currency] [varchar](50) NOT NULL,
	[Primary_Language] [varchar](50) NOT NULL,
	[Market] [varchar](50) NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblDesignation]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblDesignation](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Designation] [varchar](50) NOT NULL,
	[LevelID] [int] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblEmpStatus]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblEmpStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpStatus] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblFunction]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblFunction](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Function] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblJob_Type]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblJob_Type](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblLevel]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblLevel](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Level] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblLOB]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblLOB](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[LOB] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblMappingMst]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [WFMP].[tblMappingMst](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[CountryID] [int] NOT NULL,
	[MarketID] [int] NOT NULL,
	[SiteID] [int] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [WFMP].[tblMaster]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblMaster](
	[Employee_ID] [int] NOT NULL,
	[First_Name] [varchar](255) NULL,
	[Middle_Name] [varchar](255) NULL,
	[Last_Name] [varchar](255) NULL,
	[DesignationID] [int] NULL,
	[LevelID] [int] NULL,
	[DOJ] [datetime] NULL,
	[DOP] [datetime] NULL,
	[DOR] [datetime] NULL,
	[DPT] [varchar](10) NULL,
	[DOPS] [smalldatetime] NULL,
	[EmpStatus] [tinyint] NOT NULL,
	[TrngStatus] [tinyint] NOT NULL,
	[Job_Type] [tinyint] NULL,
	[CountryID] [int] NULL,
	[SiteID] [int] NULL,
	[FunctionId] [int] NULL,
	[LOBID] [int] NULL,
	[SkillSet] [int] NULL,
	[SubSkillSet] [int] NULL,
	[RepMgrCode] [int] NULL,
	[TeamID] [varchar](25) NULL,
	[ntName] [varchar](50) NULL,
	[ResType] [tinyint] NULL,
	[BusinessID] [int] NULL,
	[Email_Office] [varchar](255) NULL,
 CONSTRAINT [PK_tblMaster] PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblProfile]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblProfile](
	[Employee_ID] [int] NOT NULL,
	[Date_of_Birth] [datetime] NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[Email_Personal] [varchar](255) NOT NULL,
	[Contact_Number] [bigint] NOT NULL,
	[AnniversaryDate] [datetime] NULL,
	[HighestQualification] [varchar](255) NOT NULL,
	[Transport] [bit] NOT NULL,
	[Address1] [varchar](255) NOT NULL,
	[Address2] [varchar](255) NULL,
	[Landmark] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[Total_Work_Experience] [int] NULL,
	[Skill1] [varchar](255) NULL,
	[Skill2] [varchar](255) NULL,
	[Skill3] [varchar](255) NULL,
	[Alternate_Contact] [bigint] NULL,
	[EmergencyContactPerson] [varchar](255) NULL,
	[UserImage] [nvarchar](255) NULL,
	[Updated_by] [nvarchar](50) NULL,
	[Update_Date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblQry]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblQry](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Qry] [varchar](2000) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSite]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSite](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[Site] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSkillSet]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSkillSet](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[SkillSet] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblSubSkillSet]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblSubSkillSet](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[SubSkillSet] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [WFMP].[tblTrainingStatus]    Script Date: 8/24/2017 2:55:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [WFMP].[tblTrainingStatus](
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[TrngStatus] [varchar](50) NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [WFMP].[tblCountry] ON 

INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (1, N'Afghanistan', N'Kabul', N'Afghani', N'Dari Persian; Pashto', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (2, N'Albania', N'Tirane', N'Lek', N'Albanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (3, N'Algeria', N'Algiers', N'Algerian Dinar', N'Arabic; Tamazight; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (4, N'Andorra', N'Andorra la Vella', N'Euro', N'Catalan', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (5, N'Angola', N'Luanda', N'Kwanza', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (6, N'Antigua and Barbuda', N'Saint John''s', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (7, N'Argentina', N'Buenos Aires', N'Argentine Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (8, N'Armenia', N'Yerevan', N'Dram', N'Armenian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (9, N'Australia', N'Canberra', N'Australian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (10, N'Austria', N'Vienna', N'Euro', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (11, N'Azerbaijan', N'Baku', N'Manat', N'Azerbaijani', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (12, N'The Bahamas', N'Nassau', N'Bahamian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (13, N'Bahrain', N'Manama', N'Bahraini Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (14, N'Bangladesh', N'Dhaka', N'Taka', N'Bangla', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (15, N'Barbados', N'Bridgetown', N'Barbadian Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (16, N'Belarus', N'Minsk', N'Belarusian Ruble', N'Belarusian; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (17, N'Belgium', N'Brussels', N'Euro', N'Dutch; French; German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (18, N'Belize', N'Belmopan', N'Belize Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (19, N'Benin', N'Porto-Novo', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (20, N'Bhutan', N'Thimphu', N'Ngultrum', N'Dzongkha', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (21, N'Bolivia', N'La Paz; Sucre', N'Boliviano', N'Spanish; Quechua; Aymara', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (22, N'Bosnia and Herzegovina', N'Sarajevo', N'Convertible Mark', N'Bosnian; Croatian; Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (23, N'Botswana', N'Gaborone', N'Pula', N'English; Tswana', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (24, N'Brazil', N'Brasilia', N'Real', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (25, N'Brunei', N'Bandar Seri Begawan', N'Brunei Dollar', N'Malay', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (26, N'Bulgaria', N'Sofia', N'Lev', N'Bulgarian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (27, N'Burkina Faso', N'Ouagadougou', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (28, N'Burundi', N'Bujumbura', N'Burundi Franc', N'Kirundi; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (29, N'Cambodia', N'Phnom Penh', N'Riel', N'Khmer', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (30, N'Cameroon', N'Yaounde', N'Central African CFA Franc', N'French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (31, N'Canada', N'Ottawa', N'Canadian Dollar', N'English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (32, N'Cape Verde', N'Praia', N'Cape Verdean Escudo', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (33, N'Central African Republic', N'Bangui', N'Central African CFA Franc', N'Sango; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (34, N'Chad', N'N''Djamena', N'Central African CFA Franc', N'French; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (35, N'Chile', N'Santiago', N'Chilean Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (36, N'China', N'Beijing', N'Chinese Yuan', N'Mandarin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (37, N'Colombia', N'Bogota', N'Colombian Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (38, N'Comoros', N'Moroni', N'Comorian Franc', N'Comorian; Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (39, N'Democratic Republic Of the Congo', N'Kinshasa', N'Congolese Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (40, N'Republic of the Congo', N'Brazzaville', N'Central African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (41, N'Costa Rica', N'San Jose', N'Colon', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (42, N'Cote d''Ivoire (Ivory Coast)', N'Yamoussoukro; Abidjan', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (43, N'Croatia', N'Zagreb', N'Croatian', N'Kuna', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (44, N'Cuba', N'Havana', N'Cuban Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (45, N'Cyprus', N'Nicosia', N'Euro', N'Greek; Turkish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (46, N'Czech Republic', N'Prague', N'Czech Koruna', N'Czech; Slovak', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (47, N'Denmark', N'Copenhagen', N'Danish Krone', N'Danish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (48, N'Djibouti', N'Djibouti', N'Djiboutian Franc', N'Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (49, N'Dominica', N'Rosesau', N'East Caribbean Dollar', N'English; French;Antillean Creole', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (50, N'Dominican Republic', N'Santo Domingo', N'Dominican Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (51, N'East Timor (Timor-Leste)', N'Dilli', N'United States Dollar', N'Tetum; Portuguese;Iindonesian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (52, N'Ecuador', N'Quito', N'United States Dollar', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (53, N'Egypt', N'Cairo', N'Egyptian Pound', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (54, N'El Salvador', N'San Salvador', N'United States Dollar', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (55, N'Equitorial Guinea', N'Malabo', N'Central African CFA Franc', N'Spanish; French; Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (56, N'Eritrea', N'Asmara', N'Nakfa', N'Arabic; Tigrinya; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (57, N'Estonia', N'Tallinn', N'Estonian Kroon; Euro', N'Estonian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (58, N'Ethiopia', N'Addis Ababa', N'Birr', N'Amharic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (59, N'Fiji', N'Suva', N'Fijian Dollar', N'English; Bau Fijian; Hindi', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (60, N'Finland', N'Helsinki', N'Euro', N'Finnish; Swedish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (61, N'France', N'Paris', N'Euro; CFP Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (62, N'Gabon', N'Libreville', N'Central African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (63, N'The Gambia', N'Banjul', N'Dalasi', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (64, N'Georgia', N'Tbilisi', N'Lari', N'Georgian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (65, N'Germany', N'Berlin', N'Euro', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (66, N'Ghana', N'Accra', N'Ghanaian Cedi', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (67, N'Greece', N'Athens', N'Euro', N'Greek', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (68, N'Grenada', N'St. George''s', N'East Caribbean Dollar', N'English; Patois', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (69, N'Guatemala', N'Guatemala City', N'Quetzal', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (70, N'Guinea', N'Conakry', N'Guinean Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (71, N'Guinea-Bissau', N'Bissau', N'West African CFA Franc', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (72, N'Guyana', N'Georgetown', N'Guyanese Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (73, N'Haiti', N'Port-au-Prince', N'Gourde', N'Haitian Creole; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (74, N'Honduras', N'Tegucigalpa', N'Lempira', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (75, N'Hungary', N'Budapest', N'Forint', N'Hungarian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (76, N'Iceland', N'Reykjavik', N'Icelandic Krona', N'Icelandic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (77, N'India', N'New Delhi', N'Indian Rupee', N'Hindi; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (78, N'Indonesia', N'Jakarta', N'Rupiah', N'Indonesian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (79, N'Iran', N'Tehran', N'Rial', N'Persian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (80, N'Iraq', N'Baghdad', N'Iraqi Dinar', N'Arabic; Kurdish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (81, N'Republic of Ireland', N'Dublin', N'Euro', N'English; Irish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (82, N'Israel', N'Jerusalem', N'Shekel', N'Hebrew; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (83, N'Italy', N'Rome', N'Euro', N'Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (84, N'Jamaica', N'Kingston', N'Jamaican Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (85, N'Japan', N'Tokyo', N'Yen', N'Japanese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (86, N'Jordan', N'Amman', N'Jordanian Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (87, N'Kazakhstan', N'Astana', N'Tenge', N'Kazakh; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (88, N'Kenya', N'Nairobi', N'Kenyan Shilling', N'Swahili; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (89, N'Kiribati', N'Tarawa Atoll', N'Kiribati Dollar', N'English; Gilbertese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (90, N'North Korea', N'Pyongyang', N'North Korean Won', N'Korean', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (91, N'South Korea', N'Seoul', N'South Korean Won', N'Korean', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (92, N'Kosovo', N'Pristina', N'Euro', N'Albanian; Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (93, N'Kuwait', N'Kuwait City', N'Kuwaiti Dollar', N'Arabic; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (94, N'Kyrgyzstan', N'Bishkek', N'Som', N'Kyrgyz; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (95, N'Laos', N'Vientiane', N'Kip', N'Lao (Laotian)', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (96, N'Latvia', N'Riga', N'Lats', N'Latvian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (97, N'Lebanon', N'Beirut', N'Lebanese Pound', N'Arabic; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (98, N'Lesotho', N'Maseru', N'Loti', N'Sesotho; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (99, N'Liberia', N'Monrovia', N'Liberian Dollar', N'English', NULL, 1)
GO
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (100, N'Libya', N'Tripoli', N'Libyan Dinar', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (101, N'Liechtenstein', N'Vaduz', N'Swiss Franc', N'German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (102, N'Lithuania', N'Vilnius', N'Lithuanian Litas', N'Lithuanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (103, N'Luxembourg', N'Luxembourg', N'Euro', N'German; French;Luxembourgish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (104, N'Macedonia', N'Skopje', N'Macedonian Denar', N'Macedonian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (105, N'Madagascar', N'Antananarivo', N'Malagasy Ariary', N'Malagasy; French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (106, N'Malawi', N'Lilongwe', N'Malawi Kwacha', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (107, N'Malaysia', N'Kuala Lumpur', N'Ringgit', N'Malay', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (108, N'Maldives', N'Male', N'Maldivian Rufiyaa', N'Dhivehi', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (109, N'Mali', N'Bamako', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (110, N'Malta', N'Valletta', N'Euro', N'Maltese; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (111, N'Marshall Islands', N'Majuro', N'United States Dollar', N'Marshallese; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (112, N'Mauritania', N'Nouakchott', N'Ouguiya', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (113, N'Mauritius', N'Port Louis', N'Mauritian Rupee', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (114, N'Mexico', N'Mexico City', N'Mexican Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (115, N'Federal States of Micronesia', N'Palikir', N'United States Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (116, N'Moldova', N'Chisinau', N'Moldovan Leu', N'Moldovan (Romanian)', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (117, N'Monaco', N'Monaco', N'Euro', N'French; Italian; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (118, N'Mongolia', N'Ulaanbaatar', N'Togrog', N'Mongolian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (119, N'Montenegro', N'Podgorica', N'Euro', N'Montenegrin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (120, N'Morocco', N'Rabat', N'Moroccan Dirham', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (121, N'Mozambique', N'Maputo', N'Mozambican Metical', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (122, N'Myanmar (Burma)', N'Nypyidaw', N'Kyat', N'Burmese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (123, N'Namibia', N'Windhoek', N'Namibian Dollar', N'English; Afrikaans; German', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (124, N'Nauru', N'Yaren', N'Australian Dollar', N'English; Nauran', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (125, N'Nepal', N'Kathmandu', N'Nepalese Rupee', N'Nepali', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (126, N'Netherlands', N'Amsterdam; The Hague', N'Euro', N'Dutch', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (127, N'New Zealand', N'Wellington', N'New Zealand Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (128, N'Nicaragua', N'Managua', N'Cordoba', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (129, N'Niger', N'Niamey', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (130, N'Nigeria', N'Abuja', N'Naira', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (131, N'Norway', N'Oslo', N'Norwegian Krone', N'Norwegian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (132, N'Oman', N'Muscat', N'Omani Rial', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (133, N'Pakistan', N'Islamabad', N'Pakistani Rupee', N'Urdu; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (134, N'Palau', N'Melekeok', N'United States Dollar', N'English; Palauan', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (135, N'Panama', N'Panama City', N'Balboa', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (136, N'Papa New Guinea', N'Port Moresby', N'Papa New Guinean Kina', N'English; Tok Pisin;Hiri Motu', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (137, N'Paraguay', N'Asuncion', N'Guarani', N'Spanish; Guarani', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (138, N'Peru', N'Lima', N'Nuevo Sol', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (139, N'Phillipines', N'Manila', N'Phillipine Peso', N'Filipino; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (140, N'Poland', N'Warsaw', N'Zloty', N'Polish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (141, N'Portugal', N'Lisbon', N'Euro', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (142, N'Qatar', N'Doha', N'Qatari Riyal', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (143, N'Romania', N'Bucharest', N'Romanian Rupee', N'Romanian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (144, N'Russia', N'Moscow', N'Ruble', N'Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (145, N'Rwanda', N'Kigali', N'Rwandan Franc', N'Kinyarwanda; French;English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (146, N'Saint Kitts and Nevis', N'Basseterre', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (147, N'Saint Lucia', N'Castries', N'East Caribbean Dollar', N'English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (148, N'Saint Vincent and The Grenadines', N'Kingstown', N'East Caribbean Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (149, N'Samoa', N'Apia', N'Tala', N'Samoan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (150, N'San Marino', N'San Marino', N'Euro', N'Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (151, N'Sao Tome and Principe', N'Sao Tome', N'Dobra', N'Portuguese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (152, N'Saudi Arabia', N'Riyadh', N'Saudi Riyal', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (153, N'Senegal', N'Dakar', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (154, N'Serbia', N'Belgrade', N'Serbian Dinar', N'Serbian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (155, N'Seychelles', N'Victoria', N'Seychoellois Rupee', N'Seychellois Creole;French; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (156, N'Sierra Leone', N'Freetown', N'Leone', N'Krio; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (157, N'Singapore', N'Singapore', N'Singapore Dollar', N'English; Malay;Mandarin Chinese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (158, N'Slovakia', N'Bratislava', N'Euro', N'Slovak', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (159, N'Slovenia', N'Ljubljana', N'Euro', N'Slovene', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (160, N'Solomon Islands', N'Honiara', N'Solomon Islands Dollar', N'Solomons Pijin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (161, N'Somalia', N'Mogadishu', N'Somali Shilling', N'Somali; Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (162, N'South Africa', N'Pretoria; Cape Town;Bloemfontein', N'Rand', N'Zulu; Xhosa; Afrikaans', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (163, N'Spain', N'Madrid', N'Euro', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (164, N'Sri Lanka', N'Colombo', N'Sri Lankan Rupee', N'Sinhala; Tamil', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (165, N'Sudan', N'Khartoum', N'Sudanese Pound', N'Arabic; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (166, N'Suriname', N'Paramaribo', N'Surinamese Dollar', N'Dutch', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (167, N'Swaziland', N'Mbabane', N'Lilangeni', N'English; SiSwati', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (168, N'Sweden', N'Stockholm', N'Swedish Krona', N'Swedish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (169, N'Switzerland', N'Berne', N'Swiss Franc', N'German; French; Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (170, N'Syria', N'Damascus', N'Syrian Pound', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (171, N'Taiwan', N'Taipei', N'New Taiwan Dollar', N'Mandarin', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (172, N'Tajikistan', N'Dushanbe', N'Somoni', N'Tajik; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (173, N'Tanzania', N'Dar es Salaam; Dodoma', N'Tanzanian Schilling', N'Swahili', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (174, N'Thailand', N'Bangkok', N'Thai Baht', N'Thai', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (175, N'Togo', N'Lome', N'West African CFA Franc', N'French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (176, N'Tonga', N'Nuku''alofa', N'Pa''anga', N'Tongan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (177, N'Trinidad and Tobago', N'Port-of-Spain', N'Trinidad and Tobago Dollar', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (178, N'Tunisia', N'Tunis', N'Tunisian Dinar', N'Tunisian; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (179, N'Turkey', N'Ankara', N'Turkish Lira', N'Turkish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (180, N'Turkmenistan', N'Ashgabat', N'Turkmen New Manat', N'Turkmen; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (181, N'Tuvalu', N'Vaiaku', N'Tuvaluan Dollar', N'Tuvaluan; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (182, N'Uganda', N'Kampala', N'Ugandan Shilling', N'Swahili; English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (183, N'Ukraine', N'Kiev', N'Hryvnia', N'Ukranian; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (184, N'United Arab Emirates', N'Abu Dhabi', N'Dirham', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (185, N'United Kingdom', N'London', N'Pound Sterling', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (186, N'United States of America', N'Washington D.C.', N'United States Dollar', N'English; Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (187, N'Uruguay', N'Montevideo', N'Uruguayan Peso', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (188, N'Uzbekistan', N'Tashkent', N'Uzbekistan Som', N'Uzbek; Russian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (189, N'Vanuatu', N'Port-Vila', N'Vanuatu Vatu', N'Bislama; English; French', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (190, N'Vatican City', N'Vatican City', N'Euro', N'Latin; Italian', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (191, N'Venezuela', N'Caracas', N'Bolivar Fuerte', N'Spanish', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (192, N'Vietnam', N'Hanoi', N'Dong', N'Vietnamese', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (193, N'Yemen', N'Sanaa', N'Yemeni Rial', N'Arabic', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (194, N'Zambia', N'Lusaka', N'Zambian Kwacha', N'English', NULL, 1)
INSERT [WFMP].[tblCountry] ([TransID], [Country], [Capital], [Currency], [Primary_Language], [Market], [Active]) VALUES (195, N'Zimbabwe', N'Harare', N'United States Dollar', N'English', NULL, 1)
SET IDENTITY_INSERT [WFMP].[tblCountry] OFF
SET IDENTITY_INSERT [WFMP].[tblDesignation] ON 

INSERT [WFMP].[tblDesignation] ([TransID], [Designation], [LevelID], [Active]) VALUES (1, N'Sr. Software Developer', 1, 1)
SET IDENTITY_INSERT [WFMP].[tblDesignation] OFF
SET IDENTITY_INSERT [WFMP].[tblEmpStatus] ON 

INSERT [WFMP].[tblEmpStatus] ([Id], [EmpStatus]) VALUES (1, N'Active')
SET IDENTITY_INSERT [WFMP].[tblEmpStatus] OFF
SET IDENTITY_INSERT [WFMP].[tblFunction] ON 

INSERT [WFMP].[tblFunction] ([TransID], [Function], [Active]) VALUES (1, N'Analytics', 1)
SET IDENTITY_INSERT [WFMP].[tblFunction] OFF
SET IDENTITY_INSERT [WFMP].[tblJob_Type] ON 

INSERT [WFMP].[tblJob_Type] ([Id], [Type]) VALUES (1, N'Software Development')
SET IDENTITY_INSERT [WFMP].[tblJob_Type] OFF
SET IDENTITY_INSERT [WFMP].[tblLevel] ON 

INSERT [WFMP].[tblLevel] ([TransID], [Level], [Active]) VALUES (1, N'Senior', 1)
SET IDENTITY_INSERT [WFMP].[tblLevel] OFF
SET IDENTITY_INSERT [WFMP].[tblLOB] ON 

INSERT [WFMP].[tblLOB] ([TransID], [LOB], [Active]) VALUES (1, N'Workforce Management', 1)
SET IDENTITY_INSERT [WFMP].[tblLOB] OFF
SET IDENTITY_INSERT [WFMP].[tblMappingMst] ON 

INSERT [WFMP].[tblMappingMst] ([TransID], [CountryID], [MarketID], [SiteID], [Active]) VALUES (1, 77, 1, 1, 1)
SET IDENTITY_INSERT [WFMP].[tblMappingMst] OFF
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (24642, N'Soumen', N'Gomes', N'', 1, NULL, CAST(0x00009E4800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 837214, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (24801, N'Dhanesh', N'Kumar', N'', 1, NULL, CAST(0x00009E4B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (24873, N'Suresh', N'Sundar', N'', 1, NULL, CAST(0x00009EA800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (26262, N'Krishna', N'Kumar', N'', 1, NULL, CAST(0x0000A08200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (745771, N'Hina', N'Bangdiwalla', N'', 1, NULL, CAST(0x0000A57100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (748882, N'Neil', N'Dharve', N'', 1, NULL, CAST(0x0000986300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (774874, N'Ashok', N'Vishwakarma', N'', 1, NULL, CAST(0x0000A09800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 825967, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (789278, N'Swapnal', N'Patil', N'', 1, NULL, CAST(0x0000A11C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 825967, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (793792, N'Joseph', N'Furtado', N'', 1, NULL, CAST(0x0000A14D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (797269, N'Pravin', N'Aloz', N'', 1, NULL, CAST(0x0000A17000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (797595, N'Shilpa', N'Hiroji', N'', 1, NULL, CAST(0x0000A17700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (798871, N'Babita', N'Garde', N'', 1, NULL, CAST(0x0000A18500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (799532, N'Balu', N'M', N'kale', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (799533, N'Chandrakant', N'Sarkale', N'', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (799534, N'Avinash', N'Khot', N'', 1, NULL, CAST(0x0000A18C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 926861, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (801071, N'Amit', N'Bhosle', N'', 1, NULL, CAST(0x0000A19500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (801083, N'Venkatesh', N'Naik', N'', 1, NULL, CAST(0x0000A19A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 937297, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (803470, N'Vinita', N'Pereira', N'', 1, NULL, CAST(0x0000A1AF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 926861, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (803471, N'Vinod', N'Prithviraj', N'Chauhan', 1, NULL, CAST(0x0000A1AF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (808659, N'Pradeep', N'Yadav', N'', 1, NULL, CAST(0x0000A1E000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (811476, N'Prashant', N'Goradia', N'', 1, NULL, CAST(0x0000A1FC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (812585, N'Nivritti', N'Bajpai', N'', 1, NULL, CAST(0x0000A20A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (813064, N'Pritesh', N'Jitendra', N'Vora', 1, NULL, CAST(0x0000A21100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 811476, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (813067, N'Clifford', N'Bernard', N'Pereira', 1, NULL, CAST(0x0000A21100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 811476, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (816186, N'Vishal', N'Mujumdar', N'', 1, NULL, CAST(0x0000A22D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (816774, N'Lava', N'Agnihotri', N'', 1, NULL, CAST(0x0000A23500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 808659, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (817172, N'Govind', N'Bansal', N'', 1, NULL, CAST(0x0000A23500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (825967, N'Vishal', N'Shirsat', N'', 1, NULL, CAST(0x0000A28300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 923563, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (827810, N'Imran', N'Pathan', N'', 1, NULL, CAST(0x0000A29600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (828394, N'Jayesh', N'Rawal', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 868903, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (828401, N'Yogendra', N'Singh', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (828422, N'Kunal', N'Patel', N'', 1, NULL, CAST(0x0000A2A700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (828909, N'Chirag', N'Baban', N'Nawale', 1, NULL, CAST(0x0000A2AC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (829267, N'Dhanraj', N'Ranganathan', N'', 1, NULL, CAST(0x0000A2B400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (830381, N'Athang', N'Tikekar', N'', 1, NULL, CAST(0x0000A2C300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (831966, N'Pramod', N'Rajguru', N'', 1, NULL, CAST(0x0000A2D500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (833379, N'Francis', N'Chettiar', N'', 1, NULL, CAST(0x0000A2E300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (835064, N'Harsh', N'Mehta', N'', 1, NULL, CAST(0x0000A2F800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (836618, N'Amit', N'Gourav', N'', 1, NULL, CAST(0x0000A30600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (836620, N'Bhaskar', N'Ranje', N'', 1, NULL, CAST(0x0000A30600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (837214, N'Vivek', N'Vishwakarma', N'', 1, NULL, CAST(0x0000A30D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (838408, N'Puja', N'Bhatia', N'', 1, NULL, CAST(0x0000A31B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (840454, N'Sarwan', N'Singh', N'', 1, NULL, CAST(0x0000A32900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (843858, N'ManvendraPratap', N'Singh', N'', 1, NULL, CAST(0x0000A34500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (844580, N'Sudhir', N'Sutar', N'', 1, NULL, CAST(0x0000A34C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 825967, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (844898, N'Mohammed', N'Osman', N'Kaleem', 1, NULL, CAST(0x0000A34C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (845134, N'Santanu', N'Das', N'', 1, NULL, CAST(0x0000A34F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (848105, N'Durgesh', N'Rajbahak', N'', 1, NULL, CAST(0x0000A36800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 868903, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (848106, N'Melwyn', N'Noronha', N'', 1, NULL, CAST(0x0000A36800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (848628, N'Viswanath', N'', N'', 1, NULL, CAST(0x0000A36B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (848992, N'Paritosh', N'Kumar', N'Mishra', 1, NULL, CAST(0x0000A36F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (851309, N'Rajesh', N'Potdar', N'', 1, NULL, CAST(0x0000A38400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (852774, N'Cornelius', N'Nelson', N'Raj', 1, NULL, CAST(0x0000A39200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (853184, N'Solomon', N'Raj', N'', 1, NULL, CAST(0x0000A39500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (853522, N'Rogaciano', N'Fernandes', N'', 1, NULL, CAST(0x0000A39A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (856283, N'Ritesh', N'D', N'Nair', 1, NULL, CAST(0x0000A3AB00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 801071, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (856409, N'Ghansham', N'Dande', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (856410, N'Chakradhari', N'A', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (857545, N'Mahesh', N'Kedia', N'', 1, NULL, CAST(0x0000A3AE00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (857723, N'ManeshKumar', N'Mekkonath', N'', 1, NULL, CAST(0x0000A3B700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (861880, N'Sanjay', N'Panjiyar', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (861881, N'Ajay', N'Yadav', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 811476, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (861882, N'Balaji', N'Ranganathan', N'', 1, NULL, CAST(0x0000A3CC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 811476, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (862586, N'Mubeen', N'Shaikh', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (862589, N'Sachin', N'Singh', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (862590, N'Rakesh', N'Patil', N'', 1, NULL, CAST(0x0000A3D100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (864669, N'Durgesh', N'Rai', N'', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 926861, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (864671, N'Kabir', N'Singh', N'Sagoo', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (864672, N'Abhishek', N'Pawar', N'', 1, NULL, CAST(0x0000A3DF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (865630, N'Henna', N'Shaikh', N'', 1, NULL, CAST(0x0000A3E200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (865631, N'Kamran', N'Shaikh', N'', 1, NULL, CAST(0x0000A3E200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (868084, N'Taranjit', N'Singh', N'', 1, NULL, CAST(0x0000A3FB00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (868903, N'Joy', N'Kunda', N'', 1, NULL, CAST(0x0000A40400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (869214, N'Majid', N'Shaikh', N'', 1, NULL, CAST(0x0000A40A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (869805, N'Ashish', N'Safaya', N'', 1, NULL, CAST(0x0000A41700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (871095, N'Hiten', N'Shah', N'', 1, NULL, CAST(0x0000A42500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (874845, N'Mukteshwar', N'Sharma', N'', 1, NULL, CAST(0x0000A44800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (874846, N'Abdul', N'Latif', N'Ansari', 1, NULL, CAST(0x0000A44800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (876085, N'Mukesh', N'Rathod', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (876086, N'Uttam', N'Agarwal', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813064, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (876087, N'Neha', N'Chandna', N'', 1, NULL, CAST(0x0000A45600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (876851, N'Jitesh', N'Solanki', N'', 1, NULL, CAST(0x0000A45D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 801071, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (877428, N'Abhijeet', N'Chavan', N'', 1, NULL, CAST(0x0000A46400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (877429, N'Yogesh', N'Kandoi', N'', 1, NULL, CAST(0x0000A46400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878219, N'Sagar', N'Katkar', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878220, N'Ranjan', N'Dakua', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878221, N'Vishal', N'Bobhate', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878222, N'Illyas', N'Mulla', N'', 1, NULL, CAST(0x0000A46E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878516, N'Santosh', N'Bidari', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878517, N'Jeethan', N'Saldanha', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878518, N'Joseph', N'Miranda', N'', 1, NULL, CAST(0x0000A47200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (878819, N'Yogendra', N'Umrankar', N'', 1, NULL, CAST(0x0000A47500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (879597, N'Amit', N'Das', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (879598, N'Vidyalata', N'Shetty', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (879599, N'Varun', N'Sikka', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 808659, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (879600, N'Krishna', N'Vallakati', N'', 1, NULL, CAST(0x0000A47C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (880343, N'George', N'Fernandes', N'', 1, NULL, CAST(0x0000A48300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (882790, N'Anil', N'Kamble', N'', 1, NULL, CAST(0x0000A49500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934763, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (882791, N'Manoj', N'Chauhan', N'', 1, NULL, CAST(0x0000A49500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 868903, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (883061, N'Reginold', N'Roche', N'', 1, NULL, CAST(0x0000A49800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
GO
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (885555, N'Rajesh', N'Shelar', N'', 1, NULL, CAST(0x0000A4AD00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (885559, N'Imran', N'Khan', N'', 1, NULL, CAST(0x0000A4AD00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (886896, N'Rahul', N'Manoj', N'Singh', 1, NULL, CAST(0x0000A4B800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (887163, N'Rohit', N'Kusurkar', N'', 1, NULL, CAST(0x0000A4BB00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (887309, N'Ankur', N'Dubey', N'', 1, NULL, CAST(0x0000A4BF00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 24642, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (889189, N'Ramchandra', N'Sahu', N'', 1, NULL, CAST(0x0000A4CD00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (892153, N'Siddarth', N'Sharma', N'', 1, NULL, CAST(0x0000A4E500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (892154, N'Abdul', N'Gaffar', N'Shaikh', 1, NULL, CAST(0x0000A4E500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (892804, N'Raman', N'Sharma', N'', 1, NULL, CAST(0x0000A4EA00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (893919, N'Nitin', N'Kotian', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 798904, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (894060, N'Ali', N'Asghar', N'Razvi', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (894061, N'Praveen', N'Kumar', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (894062, N'Mayuresh', N'Chavan', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (894063, N'Pooja', N'Kapoor', N'', 1, NULL, CAST(0x0000A4F000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (894558, N'Anchali', N'Thakur', N'', 1, NULL, CAST(0x0000A4F700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (897386, N'Paramita', N'Mandal', N'', 1, NULL, CAST(0x0000A50C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (897387, N'Taruvar', N'Oberoi', N'', 1, NULL, CAST(0x0000A50C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813064, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (898564, N'Shariq', N'Shamim', N'Chaudhari', 1, NULL, CAST(0x0000A51300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (898831, N'Finto', N'Francis', N'Koreth', 1, NULL, CAST(0x0000A51400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (903424, N'Sridarshi', N'Kundu', N'', 1, NULL, CAST(0x0000A52F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (905328, N'Akhilesh', N'Kumar', N'', 1, NULL, CAST(0x0000A53600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (908101, N'John', N'Fernandes', N'', 1, NULL, CAST(0x0000A55200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (908308, N'Aazib', N'Ansari', N'', 1, NULL, CAST(0x0000A55200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (911686, N'Vinayak', N'Gundaram', N'', 1, NULL, CAST(0x0000A57C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (911687, N'Paramvir', N'Singh', N'', 1, NULL, CAST(0x0000A57C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (911799, N'Robinder', N'Singh', N'Oberoi', 1, NULL, CAST(0x0000A57F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (914958, N'Swapnil', N'Chandrakant', N'Karvande', 1, NULL, CAST(0x0000A59F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (918031, N'Komal', N'Trivedi', N'', 1, NULL, CAST(0x0000A5B400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 923563, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (923563, N'Gurdeep', N'', N'Singh', 1, NULL, CAST(0x0000A5E500000000 AS DateTime), CAST(0x0000A5E500000000 AS DateTime), NULL, NULL, CAST(0xA5E50000 AS SmallDateTime), 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 745771, NULL, NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (923564, N'Sashikaran', N'', N'', 1, NULL, CAST(0x0000A5E700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (924101, N'Sandip', N'Chawda', N'', 1, NULL, CAST(0x0000A5E800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (924516, N'Jyoti', N'Madhubhai', N'Dabhi', 1, NULL, CAST(0x0000A5EC00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (926860, N'Sohil', N'Feroz', N'Jesani', 1, NULL, CAST(0x0000A60100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (926861, N'Vicky', N'Fernandes', N'', 1, NULL, CAST(0x0000A60100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 928948, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (927270, N'Gautham', N'Rangarajan', N'', 1, NULL, CAST(0x0000A60400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (927271, N'Jasbir', N'Singh', N'', 1, NULL, CAST(0x0000A60400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (928948, N'Sandeep', N'Lalla', N'', 1, NULL, CAST(0x0000A60F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 893919, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (929334, N'Priya', N'Dsouza', N'', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (929335, N'Gyanendra', N'Singh', N'Bais', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (929336, N'Noel', N'Rodrigues', N'', 1, NULL, CAST(0x0000A61600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 825967, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (929843, N'Shantanu', N'Das', N'', 1, NULL, CAST(0x0000A61800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 937297, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (930516, N'Shyam', N'Verma', N'', 1, NULL, CAST(0x0000A61D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (930517, N'Faisal', N'Modan', N'', 1, NULL, CAST(0x0000A61D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (931040, N'Paras', N'Chandrakant', N'Parmar', 1, 1, CAST(0x0000A62000000000 AS DateTime), CAST(0x0000A62000000000 AS DateTime), NULL, N'1', CAST(0xA6200000 AS SmallDateTime), 1, 1, 1, 77, 1, 1, 1, 1, 1, 923563, N'1', N'pparm001', 0, 1, N'paras.parmar@sitel.com')
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (931042, N'Ashish', N'Sharma', N'', 1, NULL, CAST(0x0000A62000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (932458, N'Rushikesh', N'Patil', N'', 1, NULL, CAST(0x0000A62B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (932459, N'Rajeshwar', N'Gautam', N'', 1, NULL, CAST(0x0000A62B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (932878, N'Gursharan', N'Lail', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (932879, N'Welina', N'Parmar', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 801071, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (932880, N'Amit', N'Kamble', N'', 1, NULL, CAST(0x0000A62E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 808659, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (933438, N'Abhishek', N'Wasnik', N'', 1, NULL, CAST(0x0000A63200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934284, N'Jagdeep', N'Singh', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934285, N'Pooja', N'Singh', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934286, N'Aaditya', N'Iyer', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934287, N'Deepesh', N'kapoor', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934288, N'Lokenath', N'Guha', N'', 1, NULL, CAST(0x0000A63900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934290, N'Uma', N'Kant', N'Tiwari', 1, NULL, CAST(0x0000A63500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 868903, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934291, N'Aniket', N'Kalbade', N'', 1, NULL, CAST(0x0000A63500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934761, N'Srabani', N'Basak', N'', 1, NULL, CAST(0x0000A64000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 926861, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934763, N'Gaurang', N'Suri', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 827810, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934764, N'Sameer', N'Merchant', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (934765, N'Gaurav', N'Batra', N'', 1, NULL, CAST(0x0000A63D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (935208, N'Bhakti', N'Bhanushali', N'', 1, NULL, CAST(0x0000A64300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (935209, N'Pratik', N'Mendon', N'', 1, NULL, CAST(0x0000A64300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 937297, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (935485, N'Mujammil', N'Khan', N'', 1, NULL, CAST(0x0000A64700000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (935887, N'Martin', N'Belly', N'', 1, NULL, CAST(0x0000A64A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (936511, N'Saurabh', N'Parab', N'', 1, NULL, CAST(0x0000A65100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (936512, N'Prem', N'Mishra', N'', 1, NULL, CAST(0x0000A65100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937072, N'B.', N'Muthukumar', N'Pillai', 1, NULL, CAST(0x0000A65500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937073, N'Nandini', N'Kriplani', N'', 1, NULL, CAST(0x0000A65500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937296, N'Rahul', N'Walvekar', N'', 1, NULL, CAST(0x0000A65C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937297, N'Sandeep', N'Bodhe', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 923563, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937298, N'Vinay', N'Kumar', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (937300, N'Vinay', N'Kate', N'', 1, NULL, CAST(0x0000A65800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813064, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (939481, N'Rakesh', N'Pawar', N'', 1, NULL, CAST(0x0000A66600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (940575, N'Melvin', N'Varghese', N'', 1, NULL, CAST(0x0000A67100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (942228, N'Savio', N'Mogoveer', N'', 1, NULL, CAST(0x0000A67900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (942407, N'Krunal', N'Kapadia', N'', 1, NULL, CAST(0x0000A67B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (981583, N'Hitesh', N'Thakur', N'', 1, NULL, CAST(0x0000A67B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 937297, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (983444, N'Amit ', N'Kumar', N'Das', 1, NULL, CAST(0x0000A68600000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 812585, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (988555, N'Dhara', N'Doshi', N'', 1, NULL, CAST(0x0000A6A200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (988963, N'Rajeev', N'V', N'Menon', 1, NULL, CAST(0x0000A6A200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (989828, N'Shabarinath', N'Donthu', N'', 1, NULL, CAST(0x0000A69400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 808659, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (992104, N'Vani', N'Prasad', N'Muthyala', 1, NULL, CAST(0x0000A6A900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (993959, N'Krupendra', N'Gholap', N'', 1, NULL, CAST(0x0000A6BA00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 801071, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (995060, N'Sapna', N'Roy', N'', 1, NULL, CAST(0x0000A6BE00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (998819, N'Sandeep', N'Mishra', N'', 1, NULL, CAST(0x0000A6D300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (998838, N'Sanjay', N'Sharma', N'', 1, NULL, CAST(0x0000A6D300000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 801071, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1000903, N'Vivek', N'Kumar', N'', 1, NULL, CAST(0x0000A6EB00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861881, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1003036, N'Mahesh', N'Nathan', N'', 1, NULL, CAST(0x0000A6FE00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 787311, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1005511, N'Roja', N'Pillai', N'', 1, NULL, CAST(0x0000A70B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1005521, N'Ajit', N'Tambe', N'', 1, NULL, CAST(0x0000A70E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1006545, N'Aristo', N'Fernandes', N'', 1, NULL, CAST(0x0000A71500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 797269, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1007015, N'Chandrani', N'Dutta', N'', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1007019, N'Surabhi', N'Pavan', N'Kumar', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1007034, N'Pankaj', N'Basnal', N'', 1, NULL, CAST(0x0000A71C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828401, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1008617, N'Anupam', N'Shyamnarayan', N'Maurya', 1, NULL, CAST(0x0000A72A00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1008902, N'Anagha', N'Keni', N'', 1, NULL, CAST(0x0000A72E00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1009480, N'Henry', N'Pereira', N'', 1, NULL, CAST(0x0000A73100000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 848105, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1010643, N'Sunil', N'Maravi', N'', 1, NULL, CAST(0x0000A73C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
GO
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1014153, N'Rachita', N'Chowdhury', N'', 1, NULL, CAST(0x0000A75800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 828394, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1014327, N'Lionel', N'D''souza', N'', 1, NULL, CAST(0x0000A75800000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1015448, N'RajKumar', N'Adhude', N'', 1, NULL, CAST(0x0000A75F00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1015652, N'Lleyton', N'Roy', N'', 1, NULL, CAST(0x0000A76200000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1015689, N'Raghavendra', N'Segunala', N'', 1, NULL, CAST(0x0000A76000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 934290, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1016979, N'Dhruva', N'Chowdhary', N'', 1, NULL, CAST(0x0000A76D00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 813067, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1017601, N'Charlynn', N'Taylor', N'', 1, NULL, CAST(0x0000A77400000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 926861, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1018423, N'Farhan', N'Ansari', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 861882, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1018425, N'Tasoof', N'Noor', N'Mohd Shaikh', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1018427, N'Shivani', N'Deepak', N'Misal', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1018432, N'Deepak', N'Mor', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1018438, N'Vishvanath', N'Patil', N'', 1, NULL, CAST(0x0000A77B00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1019889, N'Manoj', N'Kataria', N'', 1, NULL, CAST(0x0000A78900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 793792, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1019892, N'Vishal', N'Deshmukh', N'', 1, NULL, CAST(0x0000A78900000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 908308, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1019895, N'Swapnil', N'Navle', N'', 1, NULL, CAST(0x0000A78500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1019898, N'Suryavanshi,', N'Juhi', N'', 1, NULL, CAST(0x0000A78500000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 830381, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1020424, N'Andrea', N'Noronha', N'', 1, NULL, CAST(0x0000A78C00000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 817172, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1020569, N'Sanket', N'Solanki', N'', 1, NULL, CAST(0x0000A79000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 882791, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblMaster] ([Employee_ID], [First_Name], [Middle_Name], [Last_Name], [DesignationID], [LevelID], [DOJ], [DOP], [DOR], [DPT], [DOPS], [EmpStatus], [TrngStatus], [Job_Type], [CountryID], [SiteID], [FunctionId], [LOBID], [SkillSet], [SubSkillSet], [RepMgrCode], [TeamID], [ntName], [ResType], [BusinessID], [Email_Office]) VALUES (1020576, N'Malla,', N'Asish', N'', 1, NULL, CAST(0x0000A79000000000 AS DateTime), NULL, NULL, N'', NULL, 1, 1, 1, NULL, NULL, 1, NULL, NULL, NULL, 803471, N'', NULL, NULL, 1, NULL)
INSERT [WFMP].[tblProfile] ([Employee_ID], [Date_of_Birth], [Gender], [Email_Personal], [Contact_Number], [AnniversaryDate], [HighestQualification], [Transport], [Address1], [Address2], [Landmark], [City], [Total_Work_Experience], [Skill1], [Skill2], [Skill3], [Alternate_Contact], [EmergencyContactPerson], [UserImage], [Updated_by], [Update_Date]) VALUES (931040, CAST(0x0000713600000000 AS DateTime), N'Male', N'parasparmar@gmail.com', 7738533134, CAST(0x0000948800000000 AS DateTime), N'', 1, N'B/407-8 Yogi Paradise CHS, Bldg 63-64 Yogi Eksar, New Link Rd, Yoginagar,', N'Borivli(W)', N'Opp Dutta Mandir', N'Mumbai', 16, N'C,DotNet,Programming Languages', N'JAVASCRIPT,JQUERY', N'Capacity Planning,Communication,Computer', 9967514545, N'Khyati Parmar', N'pparm001_0.jpg', N'pparm001', CAST(0x0000A7D900226BD1 AS DateTime))
SET IDENTITY_INSERT [WFMP].[tblQry] ON 

INSERT [WFMP].[tblQry] ([TransID], [Qry], [Active]) VALUES (1, N'[WFMP].[CE]', 1)
SET IDENTITY_INSERT [WFMP].[tblQry] OFF
SET IDENTITY_INSERT [WFMP].[tblSite] ON 

INSERT [WFMP].[tblSite] ([TransID], [Site], [Active]) VALUES (1, N'CWFM - UMANG', 1)
SET IDENTITY_INSERT [WFMP].[tblSite] OFF
SET IDENTITY_INSERT [WFMP].[tblSkillSet] ON 

INSERT [WFMP].[tblSkillSet] ([TransID], [SkillSet], [Active]) VALUES (1, N'Workforce Management', 1)
SET IDENTITY_INSERT [WFMP].[tblSkillSet] OFF
SET IDENTITY_INSERT [WFMP].[tblSubSkillSet] ON 

INSERT [WFMP].[tblSubSkillSet] ([TransID], [SubSkillSet], [Active]) VALUES (1, N'Analytics', 1)
SET IDENTITY_INSERT [WFMP].[tblSubSkillSet] OFF
SET IDENTITY_INSERT [WFMP].[tblTrainingStatus] ON 

INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (1, N'New Hire Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (2, N'Cross Skill Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (3, N'On Job Training', 1)
INSERT [WFMP].[tblTrainingStatus] ([TransID], [TrngStatus], [Active]) VALUES (4, N'On Floor', 1)
SET IDENTITY_INSERT [WFMP].[tblTrainingStatus] OFF
