using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for ReviewUpdate
/// </summary>
public class ReviewUpdate
{
    public ReviewUpdate()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public int PeriodID { get; set; }
    public int EmpCode { get; set; }
    public decimal KPIRating { get; set; }
    public int KPIID { get; set; }
    public int IsSPI { get; set; }
}

