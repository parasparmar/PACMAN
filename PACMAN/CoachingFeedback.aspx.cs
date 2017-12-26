using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;


public partial class CoachingFeedback : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    string strSQL;
    int MyEmpID;
    string reportee { get; set; }
    string pacmancycle { get; set; }




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
        title.Text = "Coaching & Feedback";

        //reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        //if (Convert.ToInt32(reportee) == MyEmpID || Convert.ToInt32(reportee) == 0)
        //{
        //    txtEscalation.Enabled = false;
        //    btnSaveEsc.Enabled = false;
        //    txtInitiative.Enabled = false;
        //    btnSaveIni.Enabled = false;
        //}
        //else
        //{
        //    txtEscalation.Enabled = true;
        //    btnSaveEsc.Enabled = true;
        //    txtInitiative.Enabled = true;
        //    btnSaveIni.Enabled = true;
        //}


        if (!IsPostBack)
        {
            //MyEmpID = 923563;
            fillddlPacmanCycle();
            fillddlSelectEmployee();
        }
    }


    private void fillddlPacmanCycle()
    {
        string emp;
        string empId;
        emp = ddlSelectEmployee.SelectedItem.Value.ToString();

        if (Convert.ToInt32(emp) == 0)
        { empId = MyEmpID.ToString(); }
        else
        { empId = emp; }

        strSQL = "CWFM_UMANG.[WFMPMS].[GetPacmanCycle]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(empId));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlPacmanCycle.DataSource = dt1;
        ddlPacmanCycle.DataTextField = "TextDescription";
        ddlPacmanCycle.DataValueField = "ID";
        ddlPacmanCycle.DataBind();


        DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlPacmanCycle");

        v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));

    }

    private void fillddlSelectEmployee()
    {
        strSQL = "CWFM_UMANG.[WFMPMS].[GetEmpforFeedandEsc]";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", Convert.ToInt32(MyEmpID.ToString()));
        DataTable dt1 = my.GetDataTableViaProcedure(ref cmd);
        ddlSelectEmployee.DataSource = dt1;
        ddlSelectEmployee.DataTextField = "MgrName";
        ddlSelectEmployee.DataValueField = "MgrID";
        ddlSelectEmployee.DataBind();
        DropDownList v = (DropDownList)PageExtensionMethods.FindControlRecursive(Master, "ddlSelectEmployee");

        v.SelectedIndex = v.Items.IndexOf(v.Items.FindByValue(MyEmpID.ToString()));

    }


    protected void ddlSelectEmployee_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlPacmanCycle();
        //fillgvEscalationlog();
        //fillgvInitiativelog();
        //getTotalScore();

        //reportee = ddlSelectEmployee.SelectedItem.Value.ToString();
        //if (Convert.ToInt32(reportee) == MyEmpID)
        //{
        //    txtEscalation.Enabled = false;
        //    btnSaveEsc.Enabled = false;
        //    txtInitiative.Enabled = false;
        //    btnSaveIni.Enabled = false;
        //}
        //else
        //{
        //    txtEscalation.Enabled = true;
        //    btnSaveEsc.Enabled = true;
        //    txtInitiative.Enabled = true;
        //    btnSaveIni.Enabled = true;
        //}
    }

    protected void ddlPacmanCycle_SelectedIndexChanged(object sender, EventArgs e)
    {
        //fillgvEscalationlog();
        //fillgvInitiativelog();
        //getTotalScore();
    }


    
    //protected void gv_PreRender(object sender, EventArgs e)
    //{
    //    GridView gv = (GridView)sender;
    //    if (gv.Rows.Count > 0)
    //    {
    //        gv.UseAccessibleHeader = true;
    //        gv.HeaderRow.TableSection = TableRowSection.TableHeader;
    //        gv.HeaderStyle.BorderStyle = BorderStyle.None;
    //        gv.BorderStyle = BorderStyle.None;
    //        gv.BorderWidth = Unit.Pixel(1);
    //    }
    //}
    //protected void HideColumn(GridView sender, string ColumnToHide)
    //{
    //    // Hides a column given its header text
    //    GridView ThisGrid = (GridView)sender;
    //    ((DataControlField)ThisGrid.Columns
    //            .Cast<DataControlField>()
    //            .Where(fld => fld.HeaderText == ColumnToHide)
    //            .SingleOrDefault()).Visible = false;
    //}
   
}