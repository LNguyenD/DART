UPDATE REPORTS
SET URL = CASE WHEN CHARINDEX('/EMReporting/Reports/', URL) = 1 THEN
	 RTRIM(substring(url, LEN('/EMReporting/Reports/') + 1, LEN(url))) ELSE URL END

