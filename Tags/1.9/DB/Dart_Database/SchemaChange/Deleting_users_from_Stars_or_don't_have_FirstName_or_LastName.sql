/*Delete users who do not have FirstName or LastName*/
delete from [Dart].[dbo].[Users]
where UserName like '%WOW\%'
and (FirstName is null or LastName is null or FirstName = '' or LastName = '')

/*Delete Stars users*/
delete from [Dart].[dbo].[Users]
where UserName like '%WOW\%'
and UserName like '%_stars'