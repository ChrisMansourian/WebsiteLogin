USE [master]
GO
/****** Object:  Database [WebsiteLoginDatabase]    Script Date: 9/7/2021 1:09:53 AM ******/
CREATE DATABASE [WebsiteLoginDatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WebsiteLoginDatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WebsiteLoginDatabase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WebsiteLoginDatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\WebsiteLoginDatabase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [WebsiteLoginDatabase] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WebsiteLoginDatabase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET RECOVERY FULL 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET  MULTI_USER 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WebsiteLoginDatabase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [WebsiteLoginDatabase] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'WebsiteLoginDatabase', N'ON'
GO
ALTER DATABASE [WebsiteLoginDatabase] SET QUERY_STORE = OFF
GO
USE [WebsiteLoginDatabase]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_checkDuplicate]    Script Date: 9/7/2021 1:09:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_checkDuplicate] 
(
)
RETURNS bit
AS
BEGIN
	
	DECLARE @result AS bit

	SELECT @result = IIF((SELECT COUNT(DISTINCT(Username)) FROM Users) - (SELECT COUNT(*) FROM Users) < 0, 0, 1)
	
	RETURN @result

END
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/7/2021 1:09:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](25) NOT NULL,
	[Password] [varchar](25) NOT NULL,
	[SessionID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [CK_Users] CHECK  (([dbo].[fn_checkDuplicate]()=(1)))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [CK_Users]
GO
/****** Object:  StoredProcedure [dbo].[usp_login]    Script Date: 9/7/2021 1:09:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_login]

@Username varchar(25),
@Password varchar(25)
	
AS
BEGIN

UPDATE Users SET SessionID = NEWID() 
WHERE Username = @Username AND Password = @Password

SELECT SessionID FROM Users
WHERE Username = @Username AND Password = @Password


END
GO
USE [master]
GO
ALTER DATABASE [WebsiteLoginDatabase] SET  READ_WRITE 
GO
