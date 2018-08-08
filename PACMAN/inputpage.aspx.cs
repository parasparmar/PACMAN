using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class inputpage : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private int[] AuthorizedIDs = new int[6] { 755882, 931040, 923563, 918031, 1092308, 798904 };
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
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
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Nine Box";

        if (!IsPostBack)
        {
            FillGvInputPage();
        }
    }

    private void FillGvInputPage()
    {
        SqlCommand cmd = new SqlCommand("SELECT Id, Comments, UpdatedBy, UpdatedOn FROM tblABC");
        DataTable dt = my.GetData(ref cmd);
        gvInputGrid.DataSource = dt;
        gvInputGrid.DataBind();
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

    protected void gvInputGrid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView gvInput = sender as GridView;
        gvInput.Rows[e.NewEditIndex].RowState = DataControlRowState.Edit;


    }

    protected void gvInputGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Update")
        {
            GridView gv = sender as GridView;
            gv.SelectedIndex = Convert.ToInt32(e.CommandArgument);
            LinkButton lb = gv.Rows[gv.SelectedIndex].FindControlRecursive("lnkSaveComments") as LinkButton;
            lnkSaveComments_Click(lb, e);
        }
    }

    protected void lnkSaveComments_Click(object sender, EventArgs e)
    {
        LinkButton lb = sender as LinkButton;
        GridViewRow gvr = lb.Parent.Parent as GridViewRow;

        int index = gvr.RowIndex;

        TextBox tComments = gvr.FindControlRecursive("lblComments") as TextBox;
        string Comments = tComments.Text.ToString();
        int id = gvr.Cells[gvr.GetGVCellUsingFieldName("Id")].Text.ToInt32();
        int UpdatedBy = MyEmpID;
        string strSQL = "UpdateTblABC";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Id", id);
        cmd.Parameters.AddWithValue("@Comments", Comments);
        cmd.Parameters.AddWithValue("@UpdatedBy", UpdatedBy);
        int rowsAffected = my.ExecuteDMLCommand(ref cmd, "", "S");
        string message = "toastr['success']('The Row has been successfuly saved.', 'Success')";
        Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", message, true);
    }

    protected void gvInputGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        FillGvInputPage();
    }
}