A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

REGISTER A USER:-
register -u $username

LOGIN A USER:-
login -u $username

LOGOUT A USER:-
logout -u $username

CREATE A SERVER :-
creates -s $s_name

JOIN A SERVER:-
join -s $s_name -u $username -r $role

PRINT MODERATORS OF CHANNELS:-
print -s $s_name

SHOW CATEGORIES OF CHANNELS:-
categories -s $s_name

CREATE A CHANNEL IN SERVER:-
createc -s $s_name -c $c_name -t $c_type 

CREATE A CATEGORY IN SERVER:-
create_cat -s $sname -c $cat_name

ADD ROLE TO CHANNEL :-
add_r_ch -s $sname -c $cname -t $c_type -r $role 

ADD CHANNEL TO CATEGORY:-
add_ch_cat -s $sname -c $cat_name -n $channel 

ADD ROLE TO A CATEGORY:-
add_r_cat -s $sname -c $cat_name -r $role

SEND MESSAGE IN CHANNEL :-
send -s $sname -c $c_name -t $c_type -m $message

DM OTHER USER:-
send_dm -u $user -m $message

SHOW DM OF OTHER USER:-
show_dm -u $user

SHOW CHANNEL MESSAGES:-
show_ch_mess -s $sname -c $cname -t $type 

WORKING TO MAKE IT MUCH BETTER!!!




