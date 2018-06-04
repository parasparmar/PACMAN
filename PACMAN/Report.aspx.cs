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

public partial class Report : System.Web.UI.Page
{
    DataTable dtEmp = new DataTable();
    Helper my = new Helper();
    private int MyEmpID { get; set; }
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
                    if (!PageExtensionMethods.AmIAllowedThisPage(MyEmpID, HttpContext.Current.Request.Url.AbsolutePath))
                    {
                        Response.Redirect("404.aspx", false);
                    }
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Employee Report";
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

                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
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
        gv_EmpList.DataSource = dt;
        gv_EmpList.DataBind();

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
        string strSQL = "WFMPMS.GetPacmanCycleforPacmanDiscussion_g ";
        SqlCommand cmd = new SqlCommand(strSQL);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlPeriod.DataSource = dt;
        ddlPeriod.DataTextField = "Period";
        ddlPeriod.DataValueField = "PeriodID";
        ddlPeriod.DataBind();


        //ddlPeriod.SelectedIndex = 0;
    }
}

