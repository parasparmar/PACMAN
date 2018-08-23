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

public partial class Grace : System.Web.UI.Page
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
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp == null)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
                    // Check if I am allowed access to the admin pages.
                    if (!PageExtensionMethods.AmIAllowedThisPage(MyEmpID, HttpContext.Current.Request.Url.AbsolutePath))
                    {
                        Response.Redirect("404.aspx", false);
                    }
                    MyName = dtEmp.Rows[0]["First_Name"].ToString() + " " + dtEmp.Rows[0]["Middle_Name"].ToString() + " " + dtEmp.Rows[0]["Last_Name"].ToString();
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());

                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Grace";
            fillddlPeriod();
            fillEmpList();

        }
        else
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp != null && dtEmp.Rows.Count <= 0)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
                    MyRepMgr = Convert.ToInt32(dtEmp.Rows[0]["RepMgrCode"].ToString());

                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
        }

        string orginalUrl = HttpContext.Current.Request.Url.AbsolutePath;


        if (!PageExtensionMethods.AmIAllowedThisPage(MyEmpID, orginalUrl))
        {
            Response.Redirect("404.aspx");
        }

    }




    private void fillEmpList()
    {
        int Period = Convert.ToInt32(ddlPeriod.SelectedValue.ToString());
        string strSQL = "PMS.fillEmpReport";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@PeriodID", Period);
        cmd.Parameters.AddWithValue("@EmpCode", MyEmpID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        gvEmpList.DataSource = dt;
        gvEmpList.DataBind();

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

    protected void ddlPeriod_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillEmpList();
    }

    private void fillddlPeriod()
    {
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlPeriod.DataSource = dt;
        ddlPeriod.DataTextField = "Period";
        ddlPeriod.DataValueField = "PeriodID";
        ddlPeriod.DataBind();        
    }

    protected void gvEmpList_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        ImageButton ibGrace = e.CommandSource as ImageButton;
        GridViewRow gvr = ibGrace.NamingContainer as GridViewRow;
        int RowIndex = gvr.RowIndex;
        int EmpCode = Convert.ToInt32(e.CommandArgument.ToString());
        int PeriodID = Convert.ToInt32(ddlPeriod.SelectedValue.ToString());
        int cellIndex = gvr.GetGVCellUsingFieldName("Grace");
        TextBox tbGrace = gvr.Cells[cellIndex].FindControl("tbGrace") as TextBox;
        decimal Grace = Decimal.Round(Convert.ToDecimal(tbGrace.Text), 2);
        string strSQL = @"UPDATE [PMS].[Eligibility] SET [Grace] = @Grace   
                        WHERE [PeriodID] = @PeriodID and EmpCode = @EmpCode";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Grace", Grace);
        cmd.Parameters.AddWithValue("@PeriodID", PeriodID);
        cmd.Parameters.AddWithValue("@EmpCode", EmpCode);
        int rows = my.ExecuteDMLCommand(ref cmd, strSQL, "E");

        fillEmpList();
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
}

