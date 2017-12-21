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
    protected string strSQL { get; set; }
    protected int MyEmpID { get; set; }

  


    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
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
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());

                    
                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Coaching & Feedback";

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
    protected void HideColumn(GridView sender, string ColumnToHide)
    {
        // Hides a column given its header text
        GridView ThisGrid = (GridView)sender;
        ((DataControlField)ThisGrid.Columns
                .Cast<DataControlField>()
                .Where(fld => fld.HeaderText == ColumnToHide)
                .SingleOrDefault()).Visible = false;
    }
   
}