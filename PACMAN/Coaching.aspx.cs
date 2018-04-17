using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;


public partial class Coaching : System.Web.UI.Page
{
    DataTable dtEmp { get; set; }
    Helper my;
    string strSQL;
    private int MyEmpID { get; set; }
    private int CoachedEmployee { get; set; }
    EmailSender Email = new EmailSender();

    protected void Page_Load(object sender, EventArgs e)
    {

        my = new Helper();
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Coaching and Feedback";

        if (!IsPostBack)
        {
            fillddlSelectEmployee();
        }
    }

    private void fillddlSelectEmployee()
    {        
        string myRole = "Coach";
        if (myRole == "Coach")
        {
            strSQL = "Select Employee_ID, dbo.getFullName(Employee_ID) as Name from WFMP.tblMaster A where A.RepMgrCode = " + MyEmpID + " and EmpStatus=1";
        }
        else
        {
            strSQL = "Select Employee_ID, dbo.getFullName(Employee_ID) as Name from WFMP.tblMaster A where A.Employee_Id = " + MyEmpID + " and EmpStatus=1";
        }
        DataTable dt1 = my.GetData(strSQL);
        ddlSelectEmployee.DataSource = dt1;
        ddlSelectEmployee.DataTextField = "Name";
        ddlSelectEmployee.DataValueField = "Employee_ID";
        ddlSelectEmployee.DataBind();        
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
            gv.FooterRow.TableSection = TableRowSection.TableFooter;
        }
    }



    protected void btnSave_Click(object sender, EventArgs e)
    {

        string strSQL = "INSERT INTO[WFMPMS].[tblCoaching]([EmpCode],[Category],[Description],[UpdatedOn],[UpdatedBy],[Active])";
        strSQL += "VALUES(@EmpCode, @Category, @Description, @UpdatedOn, @UpdatedBy, @Active)";
        int CoachedEmployee = Convert.ToInt32(ddlSelectEmployee.SelectedValue.ToString());
        
        string[] Category = { "Communication", "Knowledge", "Accuracy", "Timeliness" };
        
        for(int i = 0; i<Category.Length; i++)
        {
            TextBox tbDescription = Page.FindControlRecursive("tb" + Category[i].ToString()) as TextBox;
            if (tbDescription != null)
            {
                SqlCommand cmd = new SqlCommand(strSQL);
                cmd.Parameters.AddWithValue("@EmpCode", CoachedEmployee);
                cmd.Parameters.AddWithValue("@Category", Category[i]);
                cmd.Parameters.AddWithValue("@Description", tbDescription.Text.ToString());
                cmd.Parameters.AddWithValue("@UpdatedOn", DateTime.Now);
                cmd.Parameters.AddWithValue("@UpdatedBy", MyEmpID.ToString());
                cmd.Parameters.AddWithValue("@Active", 1);
                my.ExecuteDMLCommand(ref cmd, strSQL, "E");
                cmd.Dispose();
            }
        }
    }

    protected void btnDiscard_Click(object sender, EventArgs e)
    {

    }

    protected void ddlSelectEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        string CoachedEmployeesName = ddlSelectEmployee.SelectedItem.Text;
        ltlCoachingInputs.Text = "Coaching Inputs for " + CoachedEmployeesName;
    }
}