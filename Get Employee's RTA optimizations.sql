Use CWFM_Umang

Declare @Employee_ID int
Declare @FromDate Date 
Declare @ToDate Date
Declare @PrimaryClientID nvarchar(50)
Declare @LevelId int

Set @Employee_ID = 803471
Set @FromDate = '20170801'
Set @ToDate = '20170831'
Set @PrimaryClientID = '511TOT1'

----Set @LevelId = Select 

select A.Employee_ID, A.Name, A.Account, A.LOB
, Convert(varchar,A.Date,106) as Date, A.QStart,A.QEnd, A.TimePeriod
, sum(A.CallsOffered) as CallsOffered
, sum(A.ForecastedCallsOffered) as ForecastedCallsOffered
, Round(100*sum(A.CallsOffered) / sum(A.ForecastedCallsOffered),2) as Offered2Forecast
, sum(A.AnsweredCalls) as AnsweredCalls
, sum(A.AcceptableCalls) as AcceptableCalls
, sum(A.AbandonedCalls) as AbandonedCalls
, A.ProjectedSL
, Round(100*sum(A.AcceptableCalls) / sum(A.CallsOffered),2) as ActualSL

--- EXCEPTIONS FOR ACCOUNT : TOYS "R" US under SOW as on 01-Dec-2017
,	Case 
-- Scenario 1: Between 95&105 Offered to Forecast : Take Actual CallsOffered		
		when sum(A.CallsOffered)  between 0.95*sum(A.ForecastedCallsOffered) and 1.05*sum(A.ForecastedCallsOffered) 
		then sum(A.CallsOffered)
		 
-- Scenario 2: Greater than 105 Offered to Forecast : Take Actual CallsOffered.
	   when sum(A.CallsOffered) > 1.05*sum(A.ForecastedCallsOffered) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget) 
	   then sum(A.CallsOffered)

-- Scenario 3: Greater than 105 Offered to Forecast : Take Adjusted SL for SL < Target.
	   when sum(A.CallsOffered) > (1.05*sum(A.ForecastedCallsOffered)) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
	   then sum(A.CallsOffered)*min(A.PrimaryKPITarget)

-- Scenario 4: Lesser than 95 Offered to Forecast : Take Actual SL for SL < Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
		then sum(A.CallsOffered)

-- Scenario 5: Lesser than 95 Offered to Forecast : Take Actual SL for SL > Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget)
		then sum(A.CallsOffered)*min(A.PrimaryKPITarget)
		
		else 0 end as AdjustedAcceptableCalls

,	Case 
-- Scenario 1: Between 95&105 Offered to Forecast : Take Actual SL		
		when sum(A.CallsOffered)  between 0.95*sum(A.ForecastedCallsOffered) and 1.05*sum(A.ForecastedCallsOffered) 
		then Round(100*(sum(A.AcceptableCalls)) / sum(A.CallsOffered),2)
		 
-- Scenario 2: Greater than 105 Offered to Forecast : Take Acutal SL for SL >= Target.
	   when sum(A.CallsOffered) > 1.05*sum(A.ForecastedCallsOffered) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget) 
	   then Round(100*sum(A.AcceptableCalls) / sum(A.CallsOffered),2)

-- Scenario 3: Greater than 105 Offered to Forecast : Take Adjusted SL for SL < Target.
	   when sum(A.CallsOffered) > (1.05*sum(A.ForecastedCallsOffered)) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
	   then Round(100*min(A.PrimaryKPITarget),2)

-- Scenario 4: Lesser than 95 Offered to Forecast : Take Actual SL for SL < Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
		then Round(100*sum(A.AcceptableCalls) / sum(A.CallsOffered),2)

-- Scenario 5: Lesser than 95 Offered to Forecast : Take Actual SL for SL > Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget)
		then 100*min(A.PrimaryKPITarget)
		else 0 end as AdjustedSL

,	Case 
-- Scenario 1: Between 95&105 Offered to Forecast : Take Actual SL		
		when sum(A.CallsOffered)  between 0.95*sum(A.ForecastedCallsOffered) and 1.05*sum(A.ForecastedCallsOffered) 
		then 'Scenario 1: Between 95&105 Offered to Forecast : Take Actual SL'
		 
-- Scenario 2: Greater than 105 Offered to Forecast : Take Acutal SL for SL >= Target.
	   when sum(A.CallsOffered) > 1.05*sum(A.ForecastedCallsOffered) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget) 
	   then 'Scenario 2: Greater than 105 Offered to Forecast : Take Acutal SL for SL >= Target'

-- Scenario 3: Greater than 105 Offered to Forecast : Take Adjusted SL for SL < Target.
	   when sum(A.CallsOffered) > (1.05*sum(A.ForecastedCallsOffered)) 
	   and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
	   then 'Scenario 3: Greater than 105 Offered to Forecast : Take Adjusted SL for SL < Target'

-- Scenario 4: Lesser than 95 Offered to Forecast : Take Actual SL for SL < Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) < min(A.PrimaryKPITarget)
		then 'Scenario 4: Lesser than 95 Offered to Forecast : Take Actual SL for SL < Target'

-- Scenario 5: Lesser than 95 Offered to Forecast : Take Actual SL for SL > Target.
		when sum(A.CallsOffered) < (0.95*sum(A.ForecastedCallsOffered)) 
		and (sum(A.AcceptableCalls) / sum(A.CallsOffered)) >= min(A.PrimaryKPITarget)
		then 'Scenario 5: Lesser than 95 Offered to Forecast : Take Actual SL for SL > Target'
		else 'Exception Not Defined' end as ExceptionType

--- EXCEPTIONS FOR ACCOUNT : TOYS "R" US under SOW as on 01-Dec-2017



 from (
		Select Distinct
			A.Employee_ID, A.First_Name+' '+ A.Middle_Name +' '+ A.Last_Name as Name
			, B.Account
			, C.LOB		
			, C.SkillId	
			, D.Date
			, F.[StartTime] as RosterStarts
			, F.[EndTime] as RosterEnds
			, Dateadd(hh,H.IST,F.[StartTime]) as MyIntervalStarts
			, Dateadd(hh,H.IST,F.[EndTime]) as MyIntervalEnds
			, M.QStart
			, M.QEnd
			, D.TimePeriod			
			, G.PrimaryKPITarget 	    
			, D.CallsOffered
			, L.RevServiceLevel as ProjectedSL
			, J.RevisedCallsOffered as ForecastedCallsOffered
			, D.AnsweredCalls
			, D.AcceptableCalls
			, D.AbandonedCalls
   
		from [WFMP].[tblMaster] A
			inner join [WFMPMS].[tblEmp2Account] B on A.Employee_ID = B.EmpCode
			inner join [WFMPMS].[tblAcc2LOB] C on C.AccountID = B.PrimaryClientID
			inner join [WFMPMS].[tblBO] D on C.AccountID = D.PrimaryClientID and C.SkillId = D.SplitID
			inner join [WFMP].[RosterMst] E on E.EmpCode = B.EmpCode
			inner join [WFMPMS].[tblCalculations] G on G.ClientID = B.PrimaryClientID
			inner join [WFMPMS].[tblTimeZones] H on H.TimeZone = G.ReportingTimeZone
			inner join [WFMP].[tblShiftCode] F on F.[ShiftID] = E.[ShiftID] and E.rDate = D.Date 
			and D.TimePeriod between Dateadd(hh,H.IST,F.[StartTime]) and Dateadd(hh,H.IST,F.[EndTime])
			inner join [WFMPMS].[tblLOB2CT] I on I.LOB = C.LOB
			inner join [WFMPMS].[tblForecastCallsBO] J on J.[QueueName] = I.CT and D.Date = J.Date and D.TimePeriod = J.TimePeriod
			inner join [CWFM_Umang].[WFMPMS].[tblLOB2CT] K on C.AccountID = K.AccountID and C.LOB = K.LOB 
			inner join [CWFM_Umang].[WFMPMS].[tblIEX] L on L.CT like '%'+K.CT 
			and L.Date = D.Date and L.Time = D.TimePeriod
			inner join [WFMPMS].[tblHOOP] M on M.AccountID = D.PrimaryClientID 
			and Datepart("WEEKDAY",D.Date) = M.WeekDay and M.TimeZone = G.ReportingTimeZone 
			and D.TimePeriod between M.QStart and M.QEnd

		where 1 = 1 
			and A.Employee_ID = @Employee_ID ----803471
			and D.Date between @FromDate and @ToDate ---'20170820'
			and B.PrimaryClientID = @PrimaryClientID ----'511TOT1'	
			and D.CallsOffered > 0

			group by 	
			A.Employee_ID, A.First_Name+' '+ A.Middle_Name +' '+ A.Last_Name 
			, B.Account
			, C.LOB		
			, C.SkillId	
			, D.Date
			, F.[StartTime]
			, F.[EndTime]
			, H.IST
			, D.TimePeriod
			, M.QStart
			, M.QEnd
			, D.AcceptableCalls / D.CallsOffered
			, G.PrimaryKPITarget 
			, D.CallsOffered
			, L.RevServiceLevel
			, J.RevisedCallsOffered
			, D.AnsweredCalls
			, D.AcceptableCalls
			, D.AbandonedCalls
) A

group by
A.Employee_ID, A.Name, A.Account, A.LOB, A.Date, A.TimePeriod,A.QStart,A.QEnd, A.ProjectedSL
