-- Final Code Blocks

-- REQUIREMENTS 1 AND 9: Variables and loops, Object
-- Create a test_payment table that creates 500 fake payment entries
-- Maybe used by security team to make sure encryption works
-- Uses for loop and creates an object called payment that conforms to payment table


-- Drop Tables
drop table TEST_PAYMENT;
drop sequence test_payment_seq;
drop type PAYMENT_TY;

-- Create Payment type object
create type PAYMENT_TY as object
(Credit_Num NUMBER,
Expr_Date Date,
CVV NUMBER);
/

-- Create Test Payment table
CREATE SEQUENCE test_payment_seq START WITH 1;

create table TEST_PAYMENT
(Test_Payment_ID NUMBER DEFAULT test_payment_seq.nextval NOT NULL,
Payment PAYMENT_TY NOT NULL);
/

describe TEST_PAYMENT;

-- Create block to insert fake payments' values
declare 
    cn NUMBER;
    expr_date Date;
    cvv NUMBER;
begin
    expr_date := TO_DATE('04/23', 'MM/YY');

    for i in 1..500 loop
        cn := trunc(dbms_random.value(1000000000000000, 9999999999999999));
        cvv := trunc(dbms_random.value(100, 999));

        insert into TEST_PAYMENT values(TEST_PAYMENT_SEQ.nextval, PAYMENT_TY(cn, expr_date, cvv));
    end loop;
end;
/

select TEST_PAYMENT_ID, tp.PAYMENT.Credit_Num Credit_Num, to_char(tp.PAYMENT.Expr_Date, 'MM/YY') EXPR_DATE, tp.PAYMENT.CVV CVV from TEST_PAYMENT tp order by TEST_PAYMENT_ID;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENTS 2 AND 3: Cursor and Conditionals
-- Use cursor to go through each item and report price
-- If item is in promotion, report discounted price

declare
    in_promotion NUMBER;
    promotion_price NUMBER;
    game_name VARCHAR2(50);
    cursor item_cursor is
        select * from item where item.VIDEO_GAME_ID is not null;
    item_val item_cursor%ROWTYPE; --create an array with one row, where each field uses the table column data type
begin
    open item_cursor;
        loop
            fetch item_cursor into item_val; -- get a row
            exit when item_cursor%NOTFOUND;
                
                select count(*) into in_promotion from promotion where item_id = item_val.item_id;
                -- dbms_output.put_line(in_promotion);

                select game_name into game_name from game where game_id = item_val.VIDEO_GAME_ID;

                if in_promotion = 1 then 
                    select discount_price into promotion_price from promotion where item_id = item_val.item_id;
                    dbms_output.put_line('Discounted price for ' || game_name ||  ': ' || promotion_price);
                else 
                    dbms_output.put_line('Regular price for ' || game_name ||': ' || item_val.price);
                end if;

        end loop;
    close item_cursor;
end;
/

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 5 PT 1
-- Trigger 1
-- On insert into return, find matching item, and set it back to in-stock

-- For checking values before inserting
select * from order_detail;
select * from return;
select * from item;

Create or replace trigger RETURN_BEF_INSERT_ROW
before insert on ADMIN."RETURN"
for each row 
declare
    item_id_from_return NUMBER;
begin
    select item_id into item_id_from_return from order_detail where detail_id = :new.order_detail_id;
    update item set in_stock = 1 where item_id = item_id_from_return;
end;
/

-- item_id = 4
insert into return values (RETURN_SEQ.nextval, 4);

select * from order_detail;
select * from return;
select * from item;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 5 PT 2
-- Trigger 2
-- On delete from payment, add payment to deleted payment table
-- This will be for just in case somebody deleted their payment but wants to return an item
-- For business insurance purposes

drop table PAYMENT_DELETE_AUDIT;

Create table PAYMENT_DELETE_AUDIT
(
    User_ID NUMBER, 
    Credit_Num NUMBER,
    Expr_Date Date,
    CVV NUMBER,
    MOD_USER VARCHAR2 (20),
    MOD_TIMESTAMP DATE
);

-- select * from PAYMENT_DELETE_AUDIT;
select * from PAYMENT;

Create or replace trigger PAYMENT_AFTER_DELETE
after delete on PAYMENT 
for each row
begin 
    insert into PAYMENT_DELETE_AUDIT values (:old.user_id, :old.credit_num, :old.expr_date, :old.cvv, (SELECT sys_context('USERENV', 'CURRENT_USER') FROM dual), Sysdate);
end;
/

insert into payment values (PAYMENT_SEQ.nextval, 3, 4444333322221111, Sysdate, 000);
select * from PAYMENT;

delete from payment where payment_id = 4;
select * from PAYMENT;
select * from PAYMENT_DELETE_AUDIT;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 6 PT 1 and REQUIREMENT 4
-- Function 1 and Both Exception Handlers
-- Function that returns whether or not an item is in stock
-- Takes input for in_stock of either 1 or 0 (throws exception if not one of the two)
    -- in stock = 1, not in stock = 0 
-- Takes input for item ID
-- Returns 1 if item stock matches in_stock argument, 0 if not, and -1 if an exception is thrown

select * from item;

Create or replace function is_item_stock(id IN NUMBER, stock_bool IN NUMBER)
return NUMBER
as
found_id NUMBER;
in_stock_val NUMBER;
in_stock_matches_argument NUMBER;
not_bool EXCEPTION;
begin
    -- assume in_stock does not match stock_bool
    in_stock_matches_argument := 0;

    select count(*) into found_id from item where item_id = id;

    if found_id = 0 then 
        raise NO_DATA_FOUND;
    end if;

    if (stock_bool != 1) and (stock_bool != 0) then
        raise not_bool;
    end if; 

    select in_stock into in_stock_val from item where item_id = id;

    if stock_bool = in_stock_val then
        in_stock_matches_argument := 1;
    end if;

    return (in_stock_matches_argument);
EXCEPTION
	When NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('No data found with that item id.');
        return (-1);
    When not_bool then
        DBMS_OUTPUT.PUT_LINE('Argument for stock_bool must be either a 1 or 0 as boolean binary values.');
        return (-1);
end is_item_stock;
/

-- Tests to make sure an item is in stock
select is_item_stock(9, 1) from dual;
select is_item_stock(9, 0) from dual;

-- Tests to make sure an item is not in stock
select is_item_stock(1, 0) from dual;
select is_item_stock(1, 1) from dual;

-- Tests to make sure id_not_found exception handler works
select is_item_stock(100, 0) from dual;

-- Tests to make sure stock_bool_exception handler works
select IS_ITEM_STOCK(1, 2) from dual;
select IS_ITEM_STOCK(1, -1) from dual;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 6 PT 2 and REQUIREMENT 4
-- Function 2 
-- Function that returns whether an item is a game or a console
-- Takes either 'game' or 'console' as input (throws exception if not one of the two)
-- Returns 1 if item type matches item_type argument, 0 if not, and -1 if an exception is thrown

select * from item;

Create or replace function is_game_or_console(id in NUMBER, item_type IN VARCHAR)
return NUMBER
as
found_id NUMBER;
item_value NUMBER;
item_type_matches_argument NUMBER;
not_valid_type EXCEPTION;
begin
    -- assume item's actual type does not match item_type
    item_type_matches_argument := 0;

    select count(*) into found_id from item where item_id = id;

    if found_id = 0 then 
        raise NO_DATA_FOUND;
    end if;

    if item_type not in ('game', 'console') then
        raise not_valid_type;
    end if;

    if item_type = 'game' then
        select video_game_id into item_value from item where item_id = id;

    elsif item_type = 'console' then 
        select console_id into item_value from item where item_id = id;
    end if;

    if item_value is not null then 
        item_type_matches_argument := 1;
    end if;

    return(item_type_matches_argument);

EXCEPTION
When NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('No data found with that item id.');
    return (-1);
When not_valid_type then
    DBMS_OUTPUT.PUT_LINE('Argument for item_type must be either "game" or "console".');
    return (-1);
end;
/

-- Checks to make sure an item is a console
select is_game_or_console(1, 'console') from dual;
select is_game_or_console(1, 'game') from dual;

-- Checks to make sure an item is a game
select is_game_or_console(3, 'game') from dual;
select is_game_or_console(3, 'console') from dual;

-- Checks to make sure id_not_found exception handler works
select is_game_or_console(100, 'console') from dual;

-- Checks to make sure not_valid_type exception handler works
select is_game_or_console(1, 'not a game') from dual;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 7 PT 1
-- Procedure 1
-- Procedure that stores name for item with given id in item_name argument

Create or replace procedure sp_select_item_name(id IN NUMBER, name_val IN OUT VARCHAR2 )
as
begin
    if is_game_or_console(id, 'game') = 1 then 
        select game.game_name into name_val from item, game where item.item_id = id and item.video_game_id = game.game_id;
    elsif is_game_or_console(id, 'console') = 1 then
        select console.console_name into name_val from item, console where item.item_id = id and item.console_id = console.console_id;
    else 
        name_val := '(Item not found.)';
        DBMS_OUTPUT.PUT_LINE('Could not find game or console with that ID');
    end if;
end;
/

-- Test procedure for a game and a console
declare 
    item_name VARCHAR(50) := 'not found';
begin
    sp_select_item_name(1, item_name);
    DBMS_OUTPUT.PUT_LINE('Console for item_id = 1 is ' || item_name);
    
    sp_select_item_name(3, item_name);
    DBMS_OUTPUT.PUT_LINE('Game for item_id = 3 is ' || item_name);

    sp_select_item_name(100, item_name);
    DBMS_OUTPUT.PUT_LINE('There should be no item name for item_id = 100: ' || item_name);
end;
/


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 7 PT 2

Create or replace procedure sp_select_user_contact_info(id IN NUMBER, first_name_val IN OUT VARCHAR2, last_name_val IN OUT VARCHAR2, email_val IN OUT VARCHAR2, phone_val IN OUT NUMBER)
as
begin
    select first_name, last_name, email, phone 
    into first_name_val, last_name_val, email_val, phone_val
    from USER 
    where user_id = id;
end;
/

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- REQUIREMENT 8
-- Create a package called inventory

create or replace package INVENTORY 
as 
    function is_item_stock(id IN NUMBER, stock_bool IN NUMBER) return NUMBER;
    function is_game_or_console(id in NUMBER, item_type IN VARCHAR) return NUMBER;
    procedure sp_select_item_name(id IN NUMBER, name_val IN OUT VARCHAR2);

end INVENTORY;
/

create or replace package body INVENTORY 
as

function is_item_stock(id IN NUMBER, stock_bool IN NUMBER)
return NUMBER
as
found_id NUMBER;
in_stock_val NUMBER;
in_stock_matches_argument NUMBER;
not_bool EXCEPTION;
begin
    -- assume in_stock does not match stock_bool
    in_stock_matches_argument := 0;

    select count(*) into found_id from item where item_id = id;

    if found_id = 0 then 
        raise NO_DATA_FOUND;
    end if;

    if (stock_bool != 1) and (stock_bool != 0) then
        raise not_bool;
    end if; 

    select in_stock into in_stock_val from item where item_id = id;

    if stock_bool = in_stock_val then
        in_stock_matches_argument := 1;
    end if;

    return (in_stock_matches_argument);
EXCEPTION
	When NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('No data found with that item id.');
        return (-1);
    When not_bool then
        DBMS_OUTPUT.PUT_LINE('Argument for stock_bool must be either a 1 or 0 as boolean binary values.');
        return (-1);
end is_item_stock;

-------------------------------------------------------------------------------------------

function is_game_or_console(id in NUMBER, item_type IN VARCHAR)
return NUMBER
as
found_id NUMBER;
item_value NUMBER;
item_type_matches_argument NUMBER;
not_valid_type EXCEPTION;
begin
    -- assume item's actual type does not match item_type
    item_type_matches_argument := 0;

    select count(*) into found_id from item where item_id = id;

    if found_id = 0 then 
        raise NO_DATA_FOUND;
    end if;

    if item_type not in ('game', 'console') then
        raise not_valid_type;
    end if;

    if item_type = 'game' then
        select video_game_id into item_value from item where item_id = id;

    elsif item_type = 'console' then 
        select console_id into item_value from item where item_id = id;
    end if;

    if item_value is not null then 
        item_type_matches_argument := 1;
    end if;

    return(item_type_matches_argument);

EXCEPTION
When NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('No data found with that item id.');
    return (-1);
When not_valid_type then
    DBMS_OUTPUT.PUT_LINE('Argument for item_type must be either "game" or "console".');
    return (-1);
end is_game_or_console;

-------------------------------------------------------------------------------------------

procedure sp_select_item_name(id IN NUMBER, name_val IN OUT VARCHAR2 )
as
begin
    if is_game_or_console(id, 'game') = 1 then 
        select game.game_name into name_val from item, game where item.item_id = id and item.video_game_id = game.game_id;
    elsif is_game_or_console(id, 'console') = 1 then
        select console.console_name into name_val from item, console where item.item_id = id and item.console_id = console.console_id;
    else 
        name_val := '(Item not found.)';
        DBMS_OUTPUT.PUT_LINE('Could not find game or console with that ID');
    end if;
end sp_select_item_name;

end INVENTORY;
/