using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using EIDSS7Test.Util;
using System.Data.SqlClient;

namespace EIDSS7Test.Database
{
    public class EIDSSParameterData
    {
        //Create a SQL Server Connection - QA
        //public static SqlConnection conn = new SqlConnection(new SqlConnectionStringBuilder()
        //{
        //    DataSource = "192.255.51.85\\NGSQLTEST1",
        //    InitialCatalog = "EIDSS7_GG",
        //    UserID = "srvcEIDSS",
        //    Password = "nBZD66)"
        //}.ConnectionString
        //);

        //Create a SQL Server Connection - DEV
        public static SqlConnection conn = new SqlConnection(new SqlConnectionStringBuilder()
        {
            DataSource = "192.255.34.106\\NGSQLDEV1",
            InitialCatalog = "EIDSS7",
            UserID = "srvcEIDSS",
            Password = "nBZD66)"
        }.ConnectionString
        );

        const String directGA70Path = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\";
        const String directPath = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\";

        //Parameterization data
        public static String tlbHumanCasePath = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbHumanCase_70.csv";
        public static String tlbMonitoringSessionPath = @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbMonitoringSession_70.csv";
        public static string campaignID = null;
        public static string campaignNM = null;
        public static string campaignSTAT = null;
        public static string campaignTYPE = null;
        public static string campStartDate;
        public static DateTime campEndDate;
        public static string disease = null;
        public static string sessionID = null;
        public static string diagnosis = null;
        public static string enteredDate = null;
        public static string sessionStatus = null;
        public static string fieldsessionID = null;
        public static string sessStartDate = null;
        public static string sessCloseDate = null;
        public static string vectorType = null;
        public static string species = null;
        public static string country = null;
        public static string countryRegion = null;
        public static string countryRayon = null;
        public static string settlement = null;
        public static string settlementType = null;
        public static string settleExtName = null;
        public static string latitude = null;
        public static string longitude = null;
        public static string elevation = null;
        public static string uniquecode = null;
        public static string firstname = null;
        public static string gender = null;
        public static string citizenship = null;
        public static string dateofbirth = null;
        public static string personalID = null;
        public static string personalTypeID = null;
        public static string uniqueorgid = null;
        public static string department1 = null;
        public static string department2 = null;
        public static string department3 = null;
        public static string lastname = null;
        public static string secondname = null;
        public static string position = null;
        public static string employeeNo = null;
        public static string organization = null;
        public static string orgfullname = null;
        public static string orguniqueid = null;
        public static string abbrv = null;
        public static string org = null;
        public static string orgID = null;
        public static List<string> departments = null;

        //Private reusable method to be called by other methods to read file into another list
        private static List<string> ReadList(string file, out List<string> lines)
        {
            //Define a list to hold the data
            lines = new List<string>();

            try
            {
                //Read the data file 
                using (StreamReader r = new StreamReader(file))
                {
                    string line;
                    while ((line = r.ReadLine()) != null)
                    {
                        lines.Add(line);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception: " + ex.Message);
            }
            finally
            {
                Console.WriteLine("Executing finally block.");
            }

            return lines;
        }

        public static void GetHumanCaseTableQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	hc.strCaseID As 'Report ID'," +
                             "hc.LegacyCaseID As 'Legacy ID'," +
                             "dg.strDefault As 'Disease'," +
                            "cgs.strDefault As 'Report Status'," +
                            "ha.strFirstName As 'First Name'," +
                            "ha.strSecondName As 'Middle Name'," +
                            "ha.strLastName As 'Last Name'," +
                            "CONVERT(VARCHAR(25), hc.datEnteredDate, 101) As 'Date Entered'," +
                            "cs1.strDefault As 'Case Classification'," +
                            "sp2.strDefault As 'Hospitalization?'" +
                "FROM tlbHumanCase hc" +
                "JOIN tlbHuman ha ON ha.idfHuman = hc.idfHuman" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000111) as cgs --'rftCaseProgressStatus'" +
                "ON cgs.idfsReference = hc.idfsCaseProgressStatus" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000019) as dg        --'Tentative Diagnosis" +
                "ON dg.idfsReference = ISNULL(hc.idfsTentativeDiagnosis, 0" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000019) as dp        --'Final Diagnosis" +
                "ON dp.idfsReference = ISNULL(hc.idfsFinalDiagnosis, 0" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000011) as cs1   --'Initial Case Status" +
                "ON cs1.idfsReference = ISNULL(hc.idfsInitialCaseStatus, 0)    " +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000011) as cs2   --'Final Case Status'" +
                "ON cs2.idfsReference = ISNULL(hc.idfsFinalCaseStatus, 0)" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000100) as ts    --'Yes/No/Unknown" +
                "ON ts.idfsReference = ISNULL(hc.idfsYNTestsConducted, 0" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000100) as sp1   --'Antimicrobial Therapy" +
                "ON sp1.idfsReference = ISNULL(hc.idfsYNAntimicrobialTherapy, 0" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000100) as sp2   --'Hospitalization" +
                "ON sp2.idfsReference = ISNULL(hc.idfsYNHospitalization, 0" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000100) as sp3   --'Specimen Collected" +
                "ON sp3.idfsReference = ISNULL(hc.idfsYNSpecimenCollected, 0)" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000100) as sp4   --'Related to Outbreak?'" +
                "ON sp4.idfsReference = ISNULL(hc.idfsYNRelatedToOutbreak, 0)" +
                "LEFT JOIN   dbo.fnReferenceRepair(1, 19000064) as ot  --'Final Outcome" +
                "ON ot.idfsReference = ISNULL(hc.idfsOutcome, 0" +
                "WHERE hc.idfsTentativeDiagnosis IS NOT NULL" +
                "AND hc.LegacyCaseID IS NULL" +
                "AND hc.idfsInitialCaseStatus IS NOT NULL" +
                "AND hc.idfsYNHospitalization IS NOT NULL";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "tlbHumanCase_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public static void GetVetASCampaignQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT cp.strCampaignID As 'CAMPAIGN_ID', " +
                        "cp.strCampaignName As 'CAMPAIGN_NAME', " +
                        "cp.strCampaignID As 'CAMPAIGN_ID', " +
                        "rp3.strDefault As 'CAMPAIGN_STATUS', " +
                        "rp2.strDefault As 'CAMPAIGN_TYPE, " +
                        "rp4.strDefault As 'DISEASE', " +
                        "CONVERT(VARCHAR(25), datCampaignDateStart, 101) As 'CAMP_START_DATE', " +
                        "CONVERT(VARCHAR(25), datCampaignDateEnd, 101) As 'CAMP_END_DATE', " +
                        "FROM tlbCampaign cp " +
                        "LEFT JOIN fnReference(1, 19000019/*Diagnosis Reference*/) rp1 " +
                        "ON rp1.idfsReference = cp.idfsCampaignType " +
                        "LEFT JOIN trtHACodeList ha ON ha.intHACode = rp1.intHACode " +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000116) rp2 " +
                        "ON rp2.idfsReference=cp.idfsCampaignType" +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000115) rp3 " +
                        "ON	rp3.idfsReference = ISNULL(cp.idfsCampaignStatus, 0) " +
                        "LEFT JOIN fnReferenceRepair(1,19000019) rp4 " +
                        "ON rp4.idfsReference=cp.idfsDiagnosis " +
                        "WHERE  cp.intRowStatus = 0 AND cp.CampaignCategoryID = '10168002' " +
                            "AND rp4.strDefault IS NOT NULL " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directPath;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "VetASCampaignData.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class VetASCampaignData
        {
            public string CAMPAIGN_ID { get; set; }
            public string CAMPAIGN_NAME { get; set; }
            public string CAMPAIGN_STATUS { get; set; }
            public string CAMPAIGN_TYPE { get; set; }
            public string DISEASE { get; set; }
            public DateTime CAMP_START_DATE { get; set; }
            public string CAMP_END_DATE { get; set; }
        }

        public static void GetVetASCampaignData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\VetASCampaignData.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<VetASCampaignData>().Take(1);

                foreach (VetASCampaignData record in records)
                {
                    campaignID = record.CAMPAIGN_ID;
                    campaignNM = record.CAMPAIGN_NAME;
                    campaignSTAT = record.CAMPAIGN_ID;
                    campaignTYPE = record.CAMPAIGN_TYPE;
                    disease = record.DISEASE;
                    campStartDate = record.CAMP_START_DATE.ToString("MM/dd/yyyy");
                    campEndDate = DateTime.ParseExact(record.CAMP_END_DATE, "MM/dd/yyyy", null);
                    break;
                }
            }
        }

        public static void GetMonitoringSessionTableQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT ms.strMonitoringSessionID As 'SESSION_ID', " +
                        "st1.strDefault As 'DISEASE', " +
                        "cp.strCampaignID As 'CAMPAIGN_ID', " +
                        "ms.datEnteredDate As 'ENTERED_DATE', " +
                        "st.name As 'SESSION_STATUS', " +
                        "gs1.strDefault As 'REGION', " +
                        "gs2.strDefault As 'RAYON' " +
                        "FROM tlbMonitoringSession ms " +
                        "LEFT JOIN tlbCampaign cp ON cp.idfCampaign = ms.idfCampaign " +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000117) as st " +
                        "ON	st.idfsReference = ISNULL(ms.idfsMonitoringSessionStatus,0)" +
                        "LEFT JOIN dbo.gisBaseReference As gs1 " +
                        "ON gs1.idfsGISBaseReference = ISNULL(ms.idfsRegion,0) " +
                        "AND gs1.idfsGISReferenceType = '19000003' " +
                        "LEFT JOIN dbo.gisBaseReference As gs2 " +
                        "ON gs2.idfsGISBaseReference = ISNULL(ms.idfsRayon,0) " +
                        "AND gs2.idfsGISReferenceType = '19000002' " +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000019) as st1 " +
                        "ON	st1.idfsReference = ISNULL(ms.idfsDiagnosis,0)" +
                        "WHERE  ms.intRowStatus = 0 AND cp.strCampaignID IS NOT NULL " +
                            "AND ms.idfsMonitoringSessionStatus IS NOT NULL " +
                            "AND ms.idfsRegion IS NOT NULL " +
                            "AND ms.idfsDiagnosis IS NOT NULL " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "tlbMonitoringSession_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class HumanASSessionData
        {
            public string SESSION_ID { get; set; }
            public string DISEASE { get; set; }
            public string CAMPAIGN_ID { get; set; }
            public DateTime ENTERED_DATE { get; set; }
            public string SESSION_STATUS { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
        }

        public static void GetHumanASSessionData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbMonitoringSession_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<HumanASSessionData>().Take(1);

                foreach (HumanASSessionData record in records)
                {
                    sessionID = record.SESSION_ID;
                    diagnosis = record.DISEASE;
                    campaignID = record.CAMPAIGN_ID;
                    enteredDate = record.ENTERED_DATE.ToString("MM/dd/yyyy");
                    sessionStatus = record.SESSION_STATUS;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    break;
                }
            }
        }

        public static void GetMonitoringSessionTableNoCampaignQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT ms.strMonitoringSessionID As 'SESSION_ID', " +
                        "st1.strDefault As 'DISEASE', " +
                        "ms.datEnteredDate As 'ENTERED_DATE', " +
                        "st.name As 'SESSION_STATUS', " +
                        "gs1.strDefault As 'REGION', " +
                        "gs2.strDefault As 'RAYON' " +
                        "FROM tlbMonitoringSession ms " +
                        "LEFT JOIN tlbCampaign cp ON cp.idfCampaign = ms.idfCampaign " +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000117) as st " +
                        "ON	st.idfsReference = ISNULL(ms.idfsMonitoringSessionStatus,0)" +
                        "LEFT JOIN dbo.gisBaseReference As gs1 " +
                        "ON gs1.idfsGISBaseReference = ISNULL(ms.idfsRegion,0) " +
                        "AND gs1.idfsGISReferenceType = '19000003' " +
                        "LEFT JOIN dbo.gisBaseReference As gs2 " +
                        "ON gs2.idfsGISBaseReference = ISNULL(ms.idfsRayon,0) " +
                        "AND gs2.idfsGISReferenceType = '19000002' " +
                        "LEFT JOIN	dbo.fnReferenceRepair(1, 19000019) as st1 " +
                        "ON	st1.idfsReference = ISNULL(ms.idfsDiagnosis,0)" +
                        "WHERE  ms.intRowStatus = 0 AND cp.strCampaignID IS NULL " +
                            "AND ms.idfsMonitoringSessionStatus IS NOT NULL " +
                            "AND ms.idfsRegion IS NOT NULL " +
                            "AND ms.idfsDiagnosis IS NOT NULL " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "tlbMonitoringSessionNoCampaign_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class HumanASSessionDataNoCampaign
        {
            public string SESSION_ID { get; set; }
            public string DISEASE { get; set; }
            public DateTime ENTERED_DATE { get; set; }
            public string SESSION_STATUS { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
        }

        public static void GetHumanASSessionDataNoCampaign()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbMonitoringSessionNoCampaign_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<HumanASSessionDataNoCampaign>().Take(1);

                foreach (HumanASSessionDataNoCampaign record in records)
                {
                    sessionID = record.SESSION_ID;
                    diagnosis = record.DISEASE;
                    enteredDate = record.ENTERED_DATE.ToString("MM/dd/yyyy");
                    sessionStatus = record.SESSION_STATUS;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    break;
                }
            }
        }

        public static void GetEmployeeTableQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	a.idfEmployee As 'EMPLOYEE_NUMBER', " +
                    "b.strFamilyName As 'LAST_NAME', " +
                    "b.strFirstName As 'FIRST_NAME', " +
                    "st.strDefault As 'POSITION', " +
                    "b.strSecondName aS 'SECOND_NAME', " +
                    "b.PersonalIDValue As 'PERSONAL_ID', " +
                    "b.PersonalIDTypeID As 'PERSONAL_TYPE_ID', " +
                    "org.EnglishName As 'ORGANIZATION', " +
                    "org.strOrganizationID As 'ORGANIZATION_ID' " +
                    "FROM dbo.tlbEmployee a, dbo.tlbPerson b WITH(NOLOCK) " +
                    "LEFT JOIN	dbo.fnReferenceRepair(1, 19000073) as st " +
                    "ON	st.idfsReference = ISNULL(b.idfsStaffPosition,0)" +
                    "LEFT JOIN	dbo.fnInstitution(1) as  org " +
                    "ON	org.idfOffice = ISNULL(b.idfInstitution, 0) " +
                    "WHERE a.idfEmployee = b.idfPerson " +
                    "AND b.intRowStatus = 0 " +
                    "AND st.strDefault IS NOT NULL " +
                    "AND b.strSecondName IS NOT NULL " +
                    "AND org.EnglishName IS NOT NULL " +
                    "AND org.strOrganizationID IS NOT NULL " +
                    "AND strOrganizationID <> ' ' " +
                    "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "tlbEmployeeData_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class EmployeeData
        {
            //Define variables for all columns that are returned in the query
            public string EMPLOYEE_NUMBER { get; set; }
            public string POSITION { get; set; }
            public string LAST_NAME { get; set; }
            public string FIRST_NAME { get; set; }
            public string SECOND_NAME { get; set; }
            public string PERSONAL_ID { get; set; }
            public string PERSONAL_TYPE_ID { get; set; }
            public string ORGANIZATION { get; set; }
            public string ORGANIZATION_ID { get; set; }
        }

        public static void GetEmployeeData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\tlbEmployeeData_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<EmployeeData>().Take(1);

                foreach (EmployeeData record in records)
                {
                    employeeNo = record.EMPLOYEE_NUMBER;
                    position = record.POSITION;
                    lastname = record.LAST_NAME;
                    firstname = record.FIRST_NAME;
                    secondname = record.SECOND_NAME;
                    personalID = record.PERSONAL_ID;
                    personalTypeID = record.PERSONAL_TYPE_ID;
                    org = record.ORGANIZATION;
                    orgID = record.ORGANIZATION_ID;
                    break;
                }
            }
        }

        public static void GetDepartmentTableQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT dp.DefaultName As 'DEPARTMENT' " +
                                "FROM dbo.fnDepartment('en') dp " +
                                "GROUP BY dp.DefaultName " +
                                "HAVING COUNT(*) < 5 " +
                                "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "tlbDepartmentData_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public static void GetDepartmentQueryResults()
        {
            //Run the query
            GetDepartmentTableQueryResults();

            //Get the data that was stored in a list
            GetStoredDepartmentData();

        }

        // Store the results from the List in a variable 
        public static List<string> GetStoredDepartmentData()
        {
            departments = GetDepartmentValues();
            return departments;
        }

        //Read the .CSV file that holds the query results and store it in a List to be accessed later
        private static List<string> GetDepartmentValues()
        {
            const string file =
                @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbDepartmentData_70.csv";

            List<string> lines;
            return ReadList(file, out lines);
        }

        public class DepartmentData
        {
            //Define variables for all columns that are returned in the query
            public string DEPARTMENT { get; set; }
        }


        public static void GetDepartmentData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\EIDSS70\Georgia\tlbDepartmentData_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<DepartmentData>().Take(3);

                foreach (DepartmentData record in records)
                {
                    department1 = record.DEPARTMENT;
                    break;
                }
            }
        }

        public static void GetEmployeeAndOrgQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT b.strFamilyName As 'LAST_NAME', " +
                    "b.strFirstName As 'FIRST_NAME', " +
                    "b.strSecondName aS 'SECOND_NAME', " +
                    "b.PersonalIDValue As 'PERSONAL_ID', " +
                    "b.PersonalIDTypeID As 'PERSONAL_TYPE_ID', " +
                    "org.EnglishName As 'ABBRV', " +
                    "org.strOrganizationID As 'UNIQUE_ID', " +
                    "org.FullName As 'ORG_FULL_NAME' " +
                    "FROM dbo.tlbPerson b " +
                    "LEFT JOIN	dbo.fnReferenceRepair(1, 19000073) as st " +
                    "ON	st.idfsReference = ISNULL(b.idfsStaffPosition,0)" +
                    "LEFT JOIN	dbo.fnInstitution(1) as  org " +
                    "ON	org.idfOffice = ISNULL(b.idfInstitution, 0) " +
                    "WHERE b.intRowStatus = 0 " +
                    "AND org.strOrganizationID <> ' ' " +
                    "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directPath;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "EmployeeOrgData.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class EmployeeOrgData
        {
            //Define variables for all columns that are returned in the query
            public string LAST_NAME { get; set; }
            public string FIRST_NAME { get; set; }
            public string SECOND_NAME { get; set; }
            public string PERSONAL_ID { get; set; }
            public string PERSONAL_TYPE_ID { get; set; }
            public string ABBRV { get; set; }
            public string UNIQUE_ID { get; set; }
            public string ORG_FULL_NAME { get; set; }
        }

        public static void GetEmployeeOrgData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\EmployeeOrgData.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<EmployeeOrgData>().Take(1);

                foreach (EmployeeOrgData record in records)
                {
                    lastname = record.LAST_NAME;
                    firstname = record.FIRST_NAME;
                    secondname = record.SECOND_NAME;
                    personalID = record.PERSONAL_ID;
                    personalTypeID = record.PERSONAL_TYPE_ID;
                    orguniqueid = record.UNIQUE_ID;
                    abbrv = record.ABBRV;
                    orgfullname = record.ORG_FULL_NAME;
                    break;
                }
            }
        }

        public static void GetOrganizationQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	b.strOrganizationID As 'ORG_UNIQUE_ID', " +
                            "b.EnglishName As 'ABBRV', " +
                            "b.EnglishFullName As 'ORG_FULL_NAME' " +
                            "FROM dbo.fnInstitution(1) b, dbo.tlbOffice a WITH(NOLOCK) " +
                            "WHERE a.idfOffice = b.idfOffice " +
                            "AND a.intRowStatus = 0 " +
                            "AND b.strOrganizationID != ' ' " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "OrganizationData_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class OrganizationData
        {
            //Define variables for all columns that are returned in the query
            public string ORG_UNIQUE_ID { get; set; }
            public string ABBRV { get; set; }
            public string ORG_FULL_NAME { get; set; }
        }

        public static void GetOrganizationData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\OrganizationData_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<OrganizationData>().Take(1);

                foreach (OrganizationData record in records)
                {
                    orguniqueid = record.ORG_UNIQUE_ID;
                    abbrv = record.ABBRV;
                    organization = record.ORG_FULL_NAME;
                    break;
                }
            }
        }

        public static void GetSettlementQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT b1.strTextString As 'COUNTRY', " +
                            "a.strSettlementCode As 'UNIQUE_CODE', " +
                            "b5.strTextString As 'SETTLE_TYPE', " +
                            "b2.strTextString As 'SETTLEMENT', " +
                            "b3.strTextString As 'REGION', " +
                            "b4.strTextString As 'RAYON', " +
                            "a.dblLatitude As 'LATITUDE', " +
                            "a.dblLongitude As 'LONGITUDE', " +
                            "a.intElevation As 'ELEVATION' " +
                    "FROM dbo.gisSettlement a " +
                    "LEFT JOIN dbo.gisStringNameTranslation b1 WITH(NOLOCK)  " +
                    "ON b1.idfsGISBaseReference = a.idfsCountry " +
                        "AND b1.idfsLanguage = '10049003' " +
                    "LEFT JOIN dbo.gisStringNameTranslation b2 WITH(NOLOCK) " +
                    "ON b2.idfsGISBaseReference = a.idfsSettlement " +
                        "AND b2.idfsLanguage = '10049003' " +
                    "LEFT JOIN dbo.gisStringNameTranslation b3 WITH(NOLOCK)  " +
                    "ON b3.idfsGISBaseReference = a.idfsRegion " +
                        "AND b3.idfsLanguage = '10049003' " +
                    "JOIN dbo.gisStringNameTranslation b4 WITH(NOLOCK)  " +
                    "ON b4.idfsGISBaseReference = a.idfsRayon " +
                        "AND b4.idfsLanguage = '10049003' " +
                    "LEFT JOIN dbo.gisStringNameTranslation b5 WITH(NOLOCK)  " +
                    "ON b5.idfsGISBaseReference = a.idfsSettlementType " +
                        "AND b5.idfsLanguage = '10049003' " +
                    "WHERE a.intRowStatus = 0 " +
                    "AND a.strSettlementCode != ' ' " +
                    "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "SettlementData_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class SettlementData
        {
            //Define variables for all columns that are returned in the query
            public string COUNTRY { get; set; }
            public string UNIQUE_CODE { get; set; }
            public string SETTLE_TYPE { get; set; }
            public string SETTLEMENT { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
            public string LATITUDE { get; set; }
            public string LONGITUDE { get; set; }
            public string ELEVATION { get; set; }
        }

        public static void GetSettlementData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\SettlementData_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<SettlementData>().Take(1);

                foreach (SettlementData record in records)
                {
                    country = record.COUNTRY;
                    uniquecode = record.UNIQUE_CODE;
                    settlementType = record.SETTLE_TYPE;
                    settlement = record.SETTLEMENT;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    latitude = record.LATITUDE;
                    longitude = record.LONGITUDE;
                    elevation = record.ELEVATION;
                    break;
                }
            }
        }

        public static void GetPersonQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT hn.strLastName As 'LAST_NAME', " +
                                "hn.strSecondName As 'SECOND_NAME', " +
                                "hn.strFirstName As 'FIRST_NAME', " +
                                "CONVERT(VARCHAR(25), hn.datDateofBirth, 101) As 'DATE_OF_BIRTH', " +
                                "ps1.name As 'CITIZENSHIP', " +
                                "ps.name As 'GENDER' " +
                                "FROM tlbHuman hn " +
                                "LEFT JOIN	dbo.fnReferenceRepair(1,19000043) as ps " +
                                    "ON	ps.idfsReference = hn.idfsHumanGender " +
                                "LEFT JOIN	dbo.fnReferenceRepair(1,19000054) as ps1 " +
                                "ON	ps1.idfsReference = hn.idfsNationality " +
                                "WHERE hn.strSecondName != ' ' " +
                                "AND hn.strFirstName != ' ' " +
                                "AND hn.idfsNationality IS NOT NULL " +
                                "AND hn.idfsHumanGender IS NOT NULL " +
                                "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "PersonData_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class PersonData
        {
            //Define variables for all columns that are returned in the query
            public string LAST_NAME { get; set; }
            public string SECOND_NAME { get; set; }
            public string FIRST_NAME { get; set; }
            public string DATE_OF_BIRTH { get; set; }
            public string CITIZENSHIP { get; set; }
            public string GENDER { get; set; }
        }

        public static void GetPersonData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\PersonData_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<PersonData>().Take(1);

                foreach (PersonData record in records)
                {
                    lastname = record.LAST_NAME;
                    secondname = record.SECOND_NAME;
                    firstname = record.FIRST_NAME;
                    dateofbirth = record.DATE_OF_BIRTH;
                    citizenship = record.CITIZENSHIP;
                    gender = record.GENDER;
                    break;
                }
            }
        }

        public static void GetRegionRayonSettleQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	ct.name As 'COUNTRY', " +
                            "rg.name as 'REGION', " +
                            "ra.name as 'RAYON', " +
                            "st.name AS 'SETTLEMENT', " +
                            "sty.name As 'SETTLEMENT_TYPE', " +
                            "st.ExtendedName AS 'SETTLE_EXT_NAME', " +
                            "gs.dblLatitude As 'LATITUDE', " +
                            "gs.dblLatitude As 'LONGITUDE', " +
                            "gs.intElevatiON As 'ELEVATION' " +
                    "FROM dbo.fnGisExtendedReferenceRepair(1,19000004) st " +
                    "INNER JOIN gisSettlement gs " +
                        "ON	st.idfsReference = gs.idfsSettlement  " +
                    "JOIN tstCustomizatiONPackage tcpac ON " +
                        "tcpac.idfsCountry = gs.idfsCountry " +
                    "INNER JOIN tstSite sit " +
                        "ON	sit.idfCustomizatiONPackage=tcpac.idfCustomizatiONPackage " +
                        "AND sit.idfsSite=dbo.fnSiteID() " +
                    "LEFT JOIN fnGisReference(1, 19000005) sty " +
                        "ON sty.idfsReference = gs.idfsSettlementType " +
                    "LEFT JOIN dbo.fnGisExtendedReferenceRepair(1,19000003) rg " +
                        "ON rg.idfsReference = gs.idfsRegion " +
                    "LEFT JOIN dbo.fnGisExtendedReferenceRepair(1,19000002) ra " +
                        "ON ra.idfsReference = gs.idfsRayon " +
                    "LEFT JOIN dbo.fnGisReferenceRepair(1,19000001) ct " +
                        "ON ct.idfsReference = gs.idfsCountry " +
                    "WHERE rg.name = 'Shida Kartli' " +
                    "ORDER BY ct.name, rg.name, ra.name, NEWID() ASC ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "RegRayonSettle_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class RegRayonSettleData
        {
            //Define variables for all columns that are returned in the query
            public string COUNTRY { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
            public string SETTLEMENT { get; set; }
            public string SETTLEMENT_TYPE { get; set; }
            public string SETTLE_EXT_NAME { get; set; }
            public string LATITUDE { get; set; }
            public string LONGITUDE { get; set; }
            public string ELEVATION { get; set; }
        }

        public static void GetRegRayonSettleData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\RegRayonSettle_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<RegRayonSettleData>().Take(1);

                foreach (RegRayonSettleData record in records)
                {
                    country = record.COUNTRY;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    settlement = record.SETTLEMENT;
                    settlementType = record.SETTLEMENT_TYPE;
                    settleExtName = record.SETTLE_EXT_NAME;
                    latitude = record.LATITUDE;
                    longitude = record.LONGITUDE;
                    elevation = record.ELEVATION;
                    break;
                }
            }
        }

        public static void GetVectorSurveillanceSessionQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	vs.strSessionID As 'SESSION_ID' " +
                            "		,vs.strFieldSessionID As 'FIELD_SESSION_ID' " +
                            "		,rp1.strDefault As 'SESSION_STATUS' " +
                            "		,STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datStartDate, 101), '/0','/'),1,1,'') As 'START_DATE' " +
                            "		,STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datCloseDate, 101), '/0','/'),1,1,'') As 'CLOSE_DATE' " +
                            "		,vt.name AS 'VECTOR_TYPE' " +
                            "		,vst.name AS 'SPECIES' " +
                            "		,pt5.strDefault As 'DISEASE' " +
                            "		,rg.strDefault As 'REGION' " +
                            "		,ra.strDefault As 'RAYON' " +
                            "		,snt.strDefault As 'SETTLEMENT' " +
                            "FROM dbo.tlbVectorSurveillanceSession vs	 " +
                            " LEFT JOIN dbo.tlbVector v ON v.idfVectorSurveillanceSession = vs.idfVectorSurveillanceSession  " +
                            " LEFT JOIN dbo.fnReference(1,19000141/*Vector sub type*/) vst " +
                                " ON	vst.idfsReference = V.idfsVectorSubType	 " +
                            " LEFT JOIN dbo.fnReference(1,19000140/*Vector type*/) vt " +
                                "ON	vt.idfsReference = v.idfsVectorType " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000133) as rp1 " +
                            "ON	rp1.idfsReference = ISNULL(vs.idfsVectorSurveillanceStatus, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000135) as rp2 " +
                            "ON	rp2.idfsReference = ISNULL(v.idfsCollectionMethod, 0) " +
                            "JOIN dbo.tlbGeoLocation gl ON gl.idfGeoLocation = v.idfLocation " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000036) as rp4 " +
                            "ON	rp4.idfsReference = ISNULL(gl.idfsGeoLocationType, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000139) as rp5 " +
                            "ON	rp5.idfsReference = ISNULL(v.idfsSurrounding, 0) " +
                            " LEFT JOIN fnGisReference(1,19000001) ct " +
                             "ON ct.idfsReference = gl.idfsCountry " +
                            " LEFT JOIN fnGisReference(1,19000003) rg " +
                             "ON rg.idfsReference = gl.idfsRegion   " +
                            " LEFT JOIN fnGisReference(1,19000002) ra " +
                             "ON ra.idfsReference = gl.idfsRayon   " +
                            " LEFT JOIN fnGisReference(1,19000004) snt " +
                             "ON snt.idfsReference = gl.idfsSettlement " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000007) as rp3 " +
                            "ON	rp3.idfsReference = ISNULL(v.idfsSex, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000136) as rp6 " +
                            "ON	rp6.idfsReference = ISNULL(v.idfsDayPeriod, 0) " +
                            " LEFT JOIN dbo.fnInstitution(1) as org1 " +
                            "ON	org1.idfOffice = ISNULL(v.idfCollectedByOffice, 0) " +
                            " LEFT JOIN dbo.fnInstitution(1) as org2 " +
                            "ON	org2.idfOffice = ISNULL(v.idfIdentifiedByOffice, 0) " +
                            " LEFT JOIN tlbPerson p1 ON p1.idfPerson = v.idfCollectedByPerson " +
                            " LEFT JOIN tlbPerson p2 ON p2.idfPerson = v.idfIdentifiedByPerson " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000100) as rp7  " +
                            "ON	rp7.idfsReference = ISNULL(v.idfsEctoparasitesCollected, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000137) as rp8  " +
                            "ON	rp8.idfsReference = ISNULL(v.idfsBasisOfRecord, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000138) as rp9  " +
                            "ON	rp9.idfsReference = ISNULL(v.idfsIdentificationMethod, 0) " +
                            " LEFT JOIN tlbMaterial mt ON mt.idfVector = v.idfVector " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000087) As sp  " +
                            "ON sp.idfsReference = ISNULL(mt.idfsSampleType, 0) " +
                            " LEFT JOIN tlbTesting pt1 ON pt1.idfMaterial = mt.idfMaterial " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000105) As pt2  " +
                            "ON pt2.idfsReference = ISNULL(pt1.idfsTestResult, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000104) As pt3  " +
                            "ON pt3.idfsReference = ISNULL(pt1.idfsTestName, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000104) As pt4  " +
                            "ON pt4.idfsReference = ISNULL(pt1.idfsTestCategory, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000019) As pt5  " +
                            "ON pt5.idfsReference = ISNULL(pt1.idfsDiagnosis, 0) " +
                            "WHERE v.intRowStatus = 0 " +
                            "AND vs.intRowStatus = 0 " +
                            "AND vs.strFieldSessionID != '' " +
                            "AND gl.idfsRegion IS NOT NULL " +
                            "AND gl.idfsRayon IS NOT NULL " +
                            "AND gl.idfsSettlement IS NOT NULL " +
                            "AND pt1.idfsDiagnosis IS NOT NULL " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "VectorSurvSession_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public static void GetVectorSurvInProcessSessionsQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT	vs.strSessionID As 'SESSION_ID' " +
                            "		,vs.strFieldSessionID As 'FIELD_SESSION_ID' " +
                            "		,rp1.strDefault As 'SESSION_STATUS' " +
                            "		,STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datStartDate, 101), '/0','/'),1,1,'') As 'START_DATE' " +
                            "		,STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datCloseDate, 101), '/0','/'),1,1,'') As 'CLOSE_DATE' " +
                            "		,vt.name AS 'VECTOR_TYPE' " +
                            "		,vst.name AS 'SPECIES' " +
                            "		,pt5.strDefault As 'DISEASE' " +
                            "		,rg.strDefault As 'REGION' " +
                            "		,ra.strDefault As 'RAYON' " +
                            "		,snt.strDefault As 'SETTLEMENT' " +
                            "FROM dbo.tlbVectorSurveillanceSession vs	 " +
                            " LEFT JOIN dbo.tlbVector v ON v.idfVectorSurveillanceSession = vs.idfVectorSurveillanceSession  " +
                            " LEFT JOIN dbo.fnReference(1,19000141/*Vector sub type*/) vst " +
                                " ON	vst.idfsReference = V.idfsVectorSubType	 " +
                            " LEFT JOIN dbo.fnReference(1,19000140/*Vector type*/) vt " +
                                "ON	vt.idfsReference = v.idfsVectorType " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000133) as rp1 " +
                            "ON	rp1.idfsReference = ISNULL(vs.idfsVectorSurveillanceStatus, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000135) as rp2 " +
                            "ON	rp2.idfsReference = ISNULL(v.idfsCollectionMethod, 0) " +
                            "JOIN dbo.tlbGeoLocation gl ON gl.idfGeoLocation = v.idfLocation " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000036) as rp4 " +
                            "ON	rp4.idfsReference = ISNULL(gl.idfsGeoLocationType, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000139) as rp5 " +
                            "ON	rp5.idfsReference = ISNULL(v.idfsSurrounding, 0) " +
                            " LEFT JOIN fnGisReference(1,19000001) ct " +
                             "ON ct.idfsReference = gl.idfsCountry " +
                            " LEFT JOIN fnGisReference(1,19000003) rg " +
                             "ON rg.idfsReference = gl.idfsRegion   " +
                            " LEFT JOIN fnGisReference(1,19000002) ra " +
                             "ON ra.idfsReference = gl.idfsRayon   " +
                            " LEFT JOIN fnGisReference(1,19000004) snt " +
                             "ON snt.idfsReference = gl.idfsSettlement " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000007) as rp3 " +
                            "ON	rp3.idfsReference = ISNULL(v.idfsSex, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000136) as rp6 " +
                            "ON	rp6.idfsReference = ISNULL(v.idfsDayPeriod, 0) " +
                            " LEFT JOIN dbo.fnInstitution(1) as org1 " +
                            "ON	org1.idfOffice = ISNULL(v.idfCollectedByOffice, 0) " +
                            " LEFT JOIN dbo.fnInstitution(1) as org2 " +
                            "ON	org2.idfOffice = ISNULL(v.idfIdentifiedByOffice, 0) " +
                            " LEFT JOIN tlbPerson p1 ON p1.idfPerson = v.idfCollectedByPerson " +
                            " LEFT JOIN tlbPerson p2 ON p2.idfPerson = v.idfIdentifiedByPerson " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000100) as rp7  " +
                            "ON	rp7.idfsReference = ISNULL(v.idfsEctoparasitesCollected, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000137) as rp8  " +
                            "ON	rp8.idfsReference = ISNULL(v.idfsBasisOfRecord, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1, 19000138) as rp9  " +
                            "ON	rp9.idfsReference = ISNULL(v.idfsIdentificationMethod, 0) " +
                            " LEFT JOIN tlbMaterial mt ON mt.idfVector = v.idfVector " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000087) As sp  " +
                            "ON sp.idfsReference = ISNULL(mt.idfsSampleType, 0) " +
                            " LEFT JOIN tlbTesting pt1 ON pt1.idfMaterial = mt.idfMaterial " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000105) As pt2  " +
                            "ON pt2.idfsReference = ISNULL(pt1.idfsTestResult, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000104) As pt3  " +
                            "ON pt3.idfsReference = ISNULL(pt1.idfsTestName, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000104) As pt4  " +
                            "ON pt4.idfsReference = ISNULL(pt1.idfsTestCategory, 0) " +
                            " LEFT JOIN dbo.fnReferenceRepair(1,19000019) As pt5  " +
                            "ON pt5.idfsReference = ISNULL(pt1.idfsDiagnosis, 0) " +
                            "WHERE v.intRowStatus = 0 " +
                            "AND vs.intRowStatus = 0 " +
                            "AND rp1.strDefault = 'In process' " +
                            "ORDER BY NEWID() ";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "VectorSurvSession_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class VectorSurveillanceData
        {
            //Define variables for all columns that are returned in the query
            public string SESSION_ID { get; set; }
            public string FIELD_SESSION_ID { get; set; }
            public string SESSION_STATUS { get; set; }
            public string START_DATE { get; set; }
            public string CLOSE_DATE { get; set; }
            public string VECTOR_TYPE { get; set; }
            public string SPECIES { get; set; }
            public string DISEASE { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
            public string SETTLEMENT { get; set; }
        }

        public static void GetVectorSurvSessData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\VectorSurvSession_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<VectorSurveillanceData>().Take(1);

                foreach (VectorSurveillanceData record in records)
                {
                    sessionID = record.SESSION_ID;
                    fieldsessionID = record.FIELD_SESSION_ID;
                    sessionStatus = record.SESSION_STATUS;
                    sessStartDate = record.START_DATE;
                    sessCloseDate = record.CLOSE_DATE;
                    vectorType = record.VECTOR_TYPE;
                    species = record.SPECIES;
                    diagnosis = record.DISEASE;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    settlement = record.SETTLEMENT;
                    break;
                }
            }
        }

        public static void GetModifiedVectorSurveillanceSessionQueryResults()
        {
            try
            {
                if (conn.State == ConnectionState.Closed)
                {
                    conn.Open();
                }

                //Create a string to hold the query
                string sql = "SELECT vs.strSessionID As 'SESSION_ID' " +
                                ",vs.strFieldSessionID As 'FIELD_SESSION_ID' " +
                                ",rp1.strDefault As 'SESSION_STATUS' " +
                                ",STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datStartDate, 101), '/0','/'),1,1,'') As 'START_DATE' " +
                                ",STUFF(REPLACE('/'+CONVERT(VARCHAR(25), vs.datCloseDate, 101), '/0','/'),1,1,'') As 'CLOSE_DATE' " +
                                ",vt.name AS 'VECTOR_TYPE' " +
                                ",vst.name AS 'SPECIES'  " +
                                ",pt1.idfsDiagnosis As 'DIAGNOSIS' " +
                                ",rg.strDefault As 'REGION' " +
                                ",ra.strDefault As 'RAYON' " +
                                ",snt.strDefault As 'SETTLEMENT' " +
                            "FROM dbo.tlbVectorSurveillanceSession vs " +
                            "LEFT JOIN dbo.tlbVector v ON v.idfVectorSurveillanceSession = vs.idfVectorSurveillanceSession " +
                            "LEFT JOIN dbo.fnReference(1, 19000141) vst " +
                                 "ON  vst.idfsReference = V.idfsVectorSubType " +
                            "LEFT JOIN dbo.fnReference(1, 19000140) vt " +
                                 "ON  vt.idfsReference = v.idfsVectorType " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000133) as rp1 " +
                            "ON rp1.idfsReference = ISNULL(vs.idfsVectorSurveillanceStatus, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000135) as rp2 " +
                            "ON rp2.idfsReference = ISNULL(v.idfsCollectionMethod, 0) " +
                            "JOIN dbo.tlbGeoLocation gl ON gl.idfGeoLocation = v.idfLocation " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000036) as rp4 " +
                            "ON rp4.idfsReference = ISNULL(gl.idfsGeoLocationType, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000139) as rp5 " +
                            "ON rp5.idfsReference = ISNULL(v.idfsSurrounding, 0) " +
                            "LEFT JOIN fnGisReference(1, 19000001) ct " +
                              "ON ct.idfsReference = gl.idfsCountry " +
                            "LEFT JOIN fnGisReference(1, 19000003) rg " +
                              "ON rg.idfsReference = gl.idfsRegion " +
                            "LEFT JOIN fnGisReference(1, 19000002) ra " +
                              "ON ra.idfsReference = gl.idfsRayon " +
                            "LEFT JOIN fnGisReference(1, 19000004) snt " +
                              "ON snt.idfsReference = gl.idfsSettlement " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000007) as rp3 " +
                            "ON rp3.idfsReference = ISNULL(v.idfsSex, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000136) as rp6 " +
                            "ON rp6.idfsReference = ISNULL(v.idfsDayPeriod, 0) " +
                            "LEFT JOIN dbo.fnInstitution(1) as org1 " +
                            "ON org1.idfOffice = ISNULL(v.idfCollectedByOffice, 0) " +
                            "LEFT JOIN dbo.fnInstitution(1) as org2 " +
                            "ON org2.idfOffice = ISNULL(v.idfIdentifiedByOffice, 0) " +
                            "LEFT JOIN tlbPerson p1 ON p1.idfPerson = v.idfCollectedByPerson " +
                            "LEFT JOIN tlbPerson p2 ON p2.idfPerson = v.idfIdentifiedByPerson " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000100) as rp7 " +
                            "ON rp7.idfsReference = ISNULL(v.idfsEctoparasitesCollected, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000137) as rp8 " +
                            "ON rp8.idfsReference = ISNULL(v.idfsBasisOfRecord, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000138) as rp9 " +
                            "ON rp9.idfsReference = ISNULL(v.idfsIdentificationMethod, 0) " +
                            "LEFT JOIN tlbMaterial mt ON mt.idfVector = v.idfVector " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000087) As sp " +
                            "ON sp.idfsReference = ISNULL(mt.idfsSampleType, 0) " +
                            "LEFT JOIN tlbPensideTest pt1 ON pt1.idfMaterial = mt.idfMaterial " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000105) As pt2 " +
                            "ON pt2.idfsReference = ISNULL(pt1.idfsPensideTestResult, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000104) As pt3 " +
                            "ON pt3.idfsReference = ISNULL(pt1.idfsPensideTestName, 0) " +
                            "LEFT JOIN dbo.fnReferenceRepair(1, 19000104) As pt4 " +
                            "ON pt4.idfsReference = ISNULL(pt1.idfsPensideTestCategory, 0) " +
                            "WHERE v.intRowStatus = 0 " +
                            "AND vs.strFieldSessionID != '' " +
                            "AND vs.intRowStatus = 0 " +
                            "AND gl.idfsRegion IS NOT NULL " +
                            "AND gl.idfsRayon IS NOT NULL " +
                            "ORDER BY NEWID()";

                //Create an SQLCommand object and pass the constructor, connection string and the query string
                SqlCommand cmd = new SqlCommand(sql, conn);

                //Use the above object to create a data reader object
                SqlDataReader queryCmdReader = cmd.ExecuteReader();

                //OPTION #1 - Create a DataTable object to hold all the data
                DataTable dtEIDSS = new DataTable();

                //OPTION #1- Use the DataTable.Load(SqlReader) function to put the results of the query into the table
                dtEIDSS.Load(queryCmdReader);

                //Create directory if it does not exist
                const String directoryPath = directGA70Path;
                if (!Directory.Exists(directoryPath))
                    Directory.CreateDirectory(directoryPath);

                //Use CSVUtility to convert DataTable data to a .csv file
                dtEIDSS.ToCSV(directoryPath + "ModVectorSurvSession_70.csv");

                conn.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("Query executed successfully");
            }
        }

        public class ModVectorSurveillanceData
        {
            //Define variables for all columns that are returned in the query
            public string SESSION_ID { get; set; }
            public string FIELD_SESSION_ID { get; set; }
            public string SESSION_STATUS { get; set; }
            public string START_DATE { get; set; }
            public string CLOSE_DATE { get; set; }
            public string VECTOR_TYPE { get; set; }
            public string SPECIES { get; set; }
            public string DIAGNOSIS { get; set; }
            public string REGION { get; set; }
            public string RAYON { get; set; }
            public string SETTLEMENT { get; set; }
        }

        public static void GetModVectorSurvSessData()
        {
            //Using StreamReader and StreamWriter commands to read and write
            using (
                StreamReader sr =
                    new StreamReader(
                        @"C:\EIDSSAutomationFramework\EIDSS7-Test\EIDSSv7\EIDSSv7\DBData\ParameterData\Georgia\ModVectorSurvSession_70.csv"))
            {
                var reader = new CsvHelper.CsvReader(sr);

                //CSVReader will read the entire file into a list
                var records = reader.GetRecords<ModVectorSurveillanceData>().Take(1);

                foreach (ModVectorSurveillanceData record in records)
                {
                    sessionID = record.SESSION_ID;
                    fieldsessionID = record.FIELD_SESSION_ID;
                    sessionStatus = record.SESSION_STATUS;
                    sessStartDate = record.START_DATE;
                    sessCloseDate = record.CLOSE_DATE;
                    vectorType = record.VECTOR_TYPE;
                    species = record.SPECIES;
                    diagnosis = record.DIAGNOSIS;
                    countryRegion = record.REGION;
                    countryRayon = record.RAYON;
                    settlement = record.SETTLEMENT;
                    break;
                }
            }
        }
    }
}