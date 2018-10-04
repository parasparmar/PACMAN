using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Web.Services;

public partial class pivot : System.Web.UI.Page
{
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private string MyName { get; set; }
    private int MyRepMgr { get; set; }
    DataTable dtEmp = new DataTable();
    Helper my = new Helper();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "pivot";            
        }
    }
    
    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;

            gv.HeaderStyle.BorderStyle = BorderStyle.None;

            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
        }
    }
    
    [WebMethod]
    public static List<DataDB> GetChartData(string PeriodId)
    {
        string strSQL = string.Empty;
        strSQL = "PMS.getOverallGraceChartData";
        Helper my = new Helper();
        string constr = my.getConnectionString();
        DataTable dt = new DataTable();

        using (SqlConnection con = new SqlConnection(constr))
        {
            using (SqlCommand cmd = new SqlCommand(strSQL))
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PeriodId", PeriodId);
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
                            Grace = columns.Contains("pivot") ? drow["pivot"].ToDecimal() : 0,
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
}

