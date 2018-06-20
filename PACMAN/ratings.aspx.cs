using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ratings : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static List<DataDB> GetChartData()
    {
        string strSQL = string.Empty;

        strSQL = GetOverAllSQL();
        Helper my = new Helper();
        string constr = my.getConnectionString();
        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL))
            {
                cmd.Connection = con;
                List<DataDB> chartData = new List<DataDB>();
                con.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    dt.Load(sdr);
                    var columns = dt.Columns;
                    foreach (DataRow drow in dt.Rows)
                    {
                        chartData.Add(new DataDB
                        {
                            ReportingManager = columns.Contains("ReportingManager") ? drow["ReportingManager"].ToString() : string.Empty,
                            Role = columns.Contains("Role") ? drow["Role"].ToString() : string.Empty,
                            Level = columns.Contains("Level") ? drow["Level"].ToString() : string.Empty,
                            EmpCode = columns.Contains("EmpCode") ? drow["EmpCode"].ToInt32() : 0,
                            Employee = columns.Contains("Employee") ? drow["Employee"].ToString() : string.Empty,
                            Designation = columns.Contains("Designation") ? drow["Designation"].ToString() : string.Empty,
                            RepMgrScore = columns.Contains("RepMgrScore") ? drow["RepMgrScore"].ToDecimal() : 0,
                            RepMgrRating = columns.Contains("RepMgrRating") ? drow["RepMgrRating"].ToDecimal() : 0,
                            Grace = columns.Contains("Grace") ? drow["Grace"].ToDecimal() : 0,
                            FinalScore = columns.Contains("FinalScore") ? drow["FinalScore"].ToDecimal() : 0,
                            FinalRating = columns.Contains("FinalRating") ? drow["FinalRating"].ToDecimal() : 0,
                            IsSPI = columns.Contains("IsSPI") ? drow["IsSPI"].ToString() : string.Empty,
                            IsDefault = columns.Contains("IsDefault") ? drow["IsDefault"].ToString() : string.Empty,
                            Active = columns.Contains("Active") ? drow["Active"].ToString() : string.Empty,
                            PMSStatus = columns.Contains("PMSStatus") ? drow["PMSStatus"].ToString() : string.Empty
                        });
                    }
                }
                con.Close();
                return chartData;
            }
        }
    }
    [WebMethod]
    public static List<DataDBDetailed> GetChartDataDetailed()
    {
        string strSQL = string.Empty;
        strSQL = GetDetailedSQL();
        Helper my = new Helper();
        string constr = my.getConnectionString();
        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL))
            {
                cmd.Connection = con;
                List<DataDBDetailed> chartData = new List<DataDBDetailed>();
                con.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    dt.Load(sdr);
                    var columns = dt.Columns;
                    foreach (DataRow drow in dt.Rows)
                    {
                        chartData.Add(new DataDBDetailed
                        {
                            ReportingManager = columns.Contains("ReportingManager") ? drow["ReportingManager"].ToString() : string.Empty,
                            Role = columns.Contains("Role") ? drow["Role"].ToString() : string.Empty,
                            Level = columns.Contains("Level") ? drow["Level"].ToString() : string.Empty,
                            EmpCode = columns.Contains("EmpCode") ? drow["EmpCode"].ToInt32() : 0,
                            Employee = columns.Contains("Employee") ? drow["Employee"].ToString() : string.Empty,
                            Designation = columns.Contains("Designation") ? drow["Designation"].ToString() : string.Empty,
                            RepMgrScore = columns.Contains("RepMgrScore") ? drow["RepMgrScore"].ToDecimal() : 0,
                            RepMgrRating = columns.Contains("RepMgrRating") ? drow["RepMgrRating"].ToDecimal() : 0,
                            Grace = columns.Contains("Grace") ? drow["Grace"].ToDecimal() : 0,
                            FinalScore = columns.Contains("FinalScore") ? drow["FinalScore"].ToDecimal() : 0,
                            FinalRating = columns.Contains("FinalRating") ? drow["FinalRating"].ToDecimal() : 0,
                            IsSPI = columns.Contains("IsSPI") ? drow["IsSPI"].ToString() : string.Empty,
                            IsDefault = columns.Contains("IsDefault") ? drow["IsDefault"].ToString() : string.Empty,
                            Active = columns.Contains("Active") ? drow["Active"].ToString() : string.Empty,
                            PMSStatus = columns.Contains("PMSStatus") ? drow["PMSStatus"].ToString() : string.Empty,
                            Metrics = columns.Contains("Metrics") ? drow["Metrics"].ToString() : string.Empty,
                            KPIRating = columns.Contains("KPIRating") ? drow["KPIRating"].ToDecimal() : 0,
                            WtdScore = columns.Contains("WtdScore") ? drow["WtdScore"].ToDecimal() : 0
                        });
                    }
                }
                con.Close();
                return chartData;
            }
        }
    }
    public static string GetOverAllSQL()
    {
        string strSQL = @"select  dbo.getfullname(a.RepMgr) as ReportingManager
		        , b.Role
		        , F.Level
		        , a.EmpCode
		        , dbo.getfullname(a.EmpCode) as Employee
		        , e.Designation
		        , a.RepMgrScore
		        , a.RepMgrRating	
		        , a.Grace	
		        , a.FinalScore	
		        , a.FinalRating	
		        , Case when a.IsSPI = 1 then 'SPI' else 'Not SPI' end as IsSPI	
		        , Case when a.IsDefault = 1 then 'Default' else 'Not Default' end as IsDefault
		        , Case when a.Active = 1 then 'Active' else 'InActive' end as Active
		        , g.LockType as PMSStatus
        from pms.eligibility a
        inner join pms.role b on b.roleid = a.roleid
        inner join pms.periodmst c on c.periodid = a.periodid
        inner join wfmp.tbldesignation e on e.id = a.DesigID
        inner join wfmp.tbllevel f on f.levelid = a.levelid
        inner join PMS.Lock g on g.LockID = a.LockID
        where a.active = 1 and b.active = 1 and a.periodid = 5
        order by 1, b.Role, F.Level, e.Designation";
        return strSQL;
    }
    public static string GetDetailedSQL()
    {
        string strSQL = @"select dbo.getfullname(a.RepMgr) as ReportingManager
		                    , b.Role
		                    , F.Level
		                    , a.EmpCode
		                    , dbo.getfullname(a.EmpCode) as Employee
		                    , e.Designation
		                    , a.RepMgrScore
		                    , a.RepMgrRating
		                    , a.Grace
		                    , a.FinalScore
		                    , a.FinalRating
		                    , Case when a.IsSPI = 1 then 'SPI' else 'Not SPI' end as IsSPI
		                    , Case when a.IsDefault = 1 then 'Default' else 'Not Default' end as IsDefault
		                    , Case when a.Active = 1 then 'Active' else 'InActive' end as Active
		                    , g.LockType as PMSStatus
		                    , I.Metrics
		                    , h.KPIRating
		                    , h.KPIRating* I.Weight as WtdScore
                        from pms.eligibility a
                        inner
                        join pms.role b on b.roleid = a.roleid
                        inner
                        join pms.periodmst c on c.periodid = a.periodid
                        inner
                        join wfmp.tbldesignation e on e.id = a.DesigID
                        inner
                        join wfmp.tbllevel f on f.levelid = a.levelid
                        inner
                        join PMS.Lock g on g.LockID = a.LockID
                        inner
                        join PMS.Review h on h.eligibilityid = a.eligibilityid
                        inner
                        join WFMPMS.tblDsgn2KPIWtg I on I.id = h.kpiID
                        where a.active = 1 and b.active = 1 and a.periodid = 5
                        order by 1, b.Role, F.Level, e.Designation";
        return strSQL;
    }
}