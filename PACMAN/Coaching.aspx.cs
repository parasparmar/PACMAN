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
    private string myRole = "Coach";
    EmailSender Email = new EmailSender();
    readonly string[] Category = { "Communication", "Knowledge", "Accuracy", "Timeliness" };
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
        else
        {
            clearAllCoachingInputsPostBack();
        }

    }
    private void fillgvCoachingLog(int BatchID = 0)
    {


        CoachedEmployee = Convert.ToInt32(ddlSelectEmployee.SelectedValue);
        string strSQL = "select BatchID, ID,EmpCode,Category,Description,UpdatedOn,dbo.getFullName(UpdatedBy) as UpdatedBy,Active";
        if (myRole == "Coach")
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + CoachedEmployee + " and active = 1";
        }
        else if (myRole == "Coach" && BatchID > 0)
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + CoachedEmployee + " and BatchID = " + BatchID + " and active = 1";
        }
        else
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + MyEmpID + " and active = 1";
        }
        DataTable dtCoaching = my.GetData(strSQL);
        gvCoachingLog.DataSource = dtCoaching;
        gvCoachingLog.DataBind();

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
        int CoachedEmployee = Convert.ToInt32(ddlSelectEmployee.SelectedValue.ToString());
        string strSQL = "WFMPMS.Coaching_Save2DB";
        
        for (int i = 0; i < Category.Length; i++)
        {
            TextBox tb = Page.FindControlRecursive("tb" + Category[i].ToString()) as TextBox;            
            HiddenField hf = Page.FindControlRecursive("hf" + Category[i].ToString()) as HiddenField;

            if (tb != null)
            {
                SqlCommand cmd = new SqlCommand(strSQL);
                int ID = hf.Value != null ? Convert.ToInt32(hf.Value) : 0;
                if (hfMode.Value.ToString() == "Insert")
                {
                    cmd.Parameters.AddWithValue("@Mode", "Insert");
                }
                else if (hfMode.Value.ToString() == "Update" && ID > 0)
                {
                    cmd.Parameters.AddWithValue("@Mode", "Update");
                    cmd.Parameters.AddWithValue("@ID", ID);                    
                }
                cmd.Parameters.AddWithValue("@EmpCode", CoachedEmployee);
                cmd.Parameters.AddWithValue("@Category", Category[i]);
                cmd.Parameters.AddWithValue("@Description", tb.Text.ToString());                
                cmd.Parameters.AddWithValue("@UpdatedBy", MyEmpID);                                
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
        CoachedEmployee = Convert.ToInt32(ddlSelectEmployee.SelectedValue);
        ltlCoachingInputs.Text = "Coaching Inputs for " + CoachedEmployeesName;
        ltlPreviousCoachingInputs.Text = "Previous Coaching Inputs for " + CoachedEmployeesName;
        fillgvCoachingLog();
    }
    private void clearAllCoachingInputsPostBack()
    {
        for (int i = 0; i < Category.Length; i++)
        {
            TextBox tbDescription = Page.FindControlRecursive("tb" + Category[i].ToString()) as TextBox;
            tbDescription.Text = string.Empty;
        }
    }
    protected void gvCoachingLog_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        Button btnBatchID = e.CommandSource as Button;
        int BatchID = 0;
        if (btnBatchID != null)
        {
            BatchID = Convert.ToInt32(btnBatchID.Text);
            hfMode.Value = "Update";
            fillCoachingInputs(BatchID);
        }

    }
    private void fillCoachingInputs(int BatchID)
    {
        CoachedEmployee = Convert.ToInt32(ddlSelectEmployee.SelectedValue);
        string strSQL = "select BatchID, ID,EmpCode,Category,Description,UpdatedOn,dbo.getFullName(UpdatedBy) as UpdatedBy,Active";
        if (myRole == "Coach")
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + CoachedEmployee + " and active = 1";
        }
        else if (myRole == "Coach" && BatchID > 0)
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + CoachedEmployee + " and BatchID = " + BatchID + " and active = 1";
        }
        else
        {
            strSQL += " from WFMPMS.tblCoaching where Empcode=" + MyEmpID + " and active = 1";
        }
        DataTable dtCoaching = my.GetData(strSQL);

        for (int i = 0; i < Category.Length; i++)
        {
            TextBox tb = Page.FindControlRecursive("tb" + Category[i].ToString()) as TextBox;
            HiddenField hf = Page.FindControlRecursive("hf" + Category[i].ToString()) as HiddenField;
            DataRow[] drow = dtCoaching.Select("Category = '" + Category[i].ToString() + "'");
            if (tb != null && hf != null)
            {
                tb.Text = drow[drow.Length - 1].Field<string>("Description").ToString();
                hf.Value = drow[drow.Length - 1].Field<int>("ID").ToString();
            }
        }
    }
}