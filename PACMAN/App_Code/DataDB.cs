using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public class DataDB
{
    public string ReportingManager { get; set; }
    public string Role { get; set; }
    public string Level { get; set; }
    public int EmpCode { get; set; }
    public string Employee { get; set; }
    public string Designation { get; set; }
    public decimal RepMgrScore { get; set; }
    public decimal RepMgrRating { get; set; }
    public decimal Grace { get; set; }
    public decimal FinalScore { get; set; }
    public decimal FinalRating { get; set; }
    public string IsSPI { get; set; }
    public string IsDefault { get; set; }
    public string Active { get; set; }
    public string PMSStatus { get; set; }

}

public class DataDBDetailed
{
    public string ReportingManager { get; set; }
    public string Role { get; set; }
    public string Level { get; set; }
    public int EmpCode { get; set; }
    public string Employee { get; set; }
    public string Designation { get; set; }
    public decimal RepMgrScore { get; set; }
    public decimal RepMgrRating { get; set; }
    public decimal Grace { get; set; }
    public decimal FinalScore { get; set; }
    public decimal FinalRating { get; set; }
    public string IsSPI { get; set; }
    public string IsDefault { get; set; }
    public string Active { get; set; }
    public string PMSStatus { get; set; }
    public string Metrics { get; set; }
    public decimal KPIRating { get; set; }
    public decimal WtdScore { get; set; }

}
