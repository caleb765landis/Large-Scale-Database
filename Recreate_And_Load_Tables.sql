-- Drop tables
drop table ADMIN."USER";

drop table ADMIN."ORDER";

drop table ADMIN.ORDER_DETAIL;

drop table ADMIN.PAYMENT;

drop table ADMIN.SHIPPING_INFO;

drop table ADMIN.STATE;

drop table ADMIN.ITEM;

drop table ADMIN.CONSOLE;

drop table ADMIN.GAME;

drop table ADMIN.RETURN;

drop table ADMIN.PURCHASE_RECORD;

drop table ADMIN.SELLER;

drop table ADMIN.PROMOTION;

drop table ADMIN.OWNER;

drop table ADMIN.ADMIN;


-- Drop sequences
drop sequence user_seq;

drop sequence order_seq;

drop sequence order_detail_seq;

drop sequence payment_seq;

drop sequence shipping_info_seq;

drop sequence state_seq;

drop sequence item_seq;

drop sequence console_seq;

drop sequence game_seq;

drop sequence return_seq;

drop sequence purchase_record_seq;

drop sequence seller_seq;

drop sequence promotion_seq;

drop sequence owner_seq;

drop sequence admin_seq;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE user_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN."USER" 
    ( 
     User_ID    NUMBER        DEFAULT user_seq.nextval NOT NULL ,
     FirstName VARCHAR2 (50)  NOT NULL , 
     LastName  VARCHAR2 (50)  NOT NULL , 
     Username  VARCHAR2 (50)  NOT NULL , 
     Email     VARCHAR2 (50)  NOT NULL , 
     Phone     NUMBER  NOT NULL 
    );

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN."USER" 
    ADD CONSTRAINT USER_PK PRIMARY KEY ( USER_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE order_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN."ORDER" 
    ( 
     ORDER_ID          NUMBER  DEFAULT order_seq.nextval NOT NULL , 
     USER_ID           NUMBER  NOT NULL , 
     PLACE_DATE        DATE  NOT NULL , 
     DELIVERY_DATE     DATE , 
     TOTAL_PAYMENT_DUE FLOAT  NOT NULL , 
     PAYMENT_ID        NUMBER  NOT NULL , 
     SHIPPING_ID       NUMBER  NOT NULL , 
     SHIPMENT_METHOD   VARCHAR2 (50)  NOT NULL 
    ) 
    TABLESPACE DATA 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN."ORDER" 
    ADD CONSTRAINT ORDER_PK PRIMARY KEY ( ORDER_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE order_detail_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.ORDER_DETAIL 
    ( 
     DETAIL_ID NUMBER  DEFAULT order_detail_seq.nextval NOT NULL , 
     ORDER_ID  NUMBER  NOT NULL , 
     ITEM_ID   NUMBER  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.ORDER_DETAIL 
    ADD CONSTRAINT ORDER_DETAIL_PK PRIMARY KEY ( DETAIL_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE payment_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.PAYMENT 
    ( 
     PAYMENT_ID NUMBER  DEFAULT payment_seq.nextval NOT NULL , 
     USER_ID    NUMBER  NOT NULL , 
     CREDIT_NUM NUMBER  NOT NULL , 
     EXPR_DATE  DATE  NOT NULL , 
     CVV        NUMBER  NOT NULL 
    ) 
    TABLESPACE DATA 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.PAYMENT 
    ADD CONSTRAINT PAYMENT_PK PRIMARY KEY ( 
    PAYMENT_ID  
    ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE shipping_info_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.SHIPPING_INFO 
    ( 
     SHIPPING_ID NUMBER  DEFAULT shipping_info_seq.nextval NOT NULL , 
     USER_ID     NUMBER  NOT NULL , 
     ADDRESS_1   VARCHAR2 (50)  NOT NULL , 
     ADDRESS_2   VARCHAR2 (50) , 
     CITY        VARCHAR2 (50)  NOT NULL , 
     STATE_ID    NUMBER  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.SHIPPING_INFO 
    ADD CONSTRAINT SHIPPING_INFO_PK PRIMARY KEY ( SHIPPING_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE state_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.STATE 
    ( 
     STATE_ID NUMBER  DEFAULT state_seq.nextval NOT NULL , 
     NAME     VARCHAR2 (50)  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.STATE 
    ADD CONSTRAINT STATE_PK PRIMARY KEY ( STATE_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE item_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.ITEM 
    ( 
     ITEM_ID       NUMBER  DEFAULT item_seq.nextval NOT NULL , 
     VIDEO_GAME_ID NUMBER , 
     CONSOLE_ID    NUMBER , 
     PRICE         FLOAT  NOT NULL , 
     IN_STOCK      INT  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.ITEM 
    ADD CONSTRAINT ITEM_PK PRIMARY KEY ( ITEM_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE console_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.CONSOLE 
    ( 
     CONSOLE_ID   NUMBER  DEFAULT console_seq.nextval NOT NULL , 
     CONSOLE_NAME VARCHAR2 (128)  NOT NULL , 
     MANUFACTURER VARCHAR2 (20)  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.CONSOLE 
    ADD CONSTRAINT CONSOLE_PK PRIMARY KEY ( CONSOLE_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE game_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.GAME 
    ( 
     GAME_ID   NUMBER  DEFAULT game_seq.nextval NOT NULL  , 
     GAME_NAME VARCHAR2 (128)  NOT NULL , 
     PUBLISHER VARCHAR2 (50)  NOT NULL 
    ) 
    TABLESPACE DATA 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.GAME 
    ADD CONSTRAINT GAME_PK PRIMARY KEY ( GAME_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE return_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.RETURN 
    ( 
     RETURN_ID       NUMBER  DEFAULT return_seq.nextval NOT NULL , 
     ORDER_DETAIL_ID NUMBER  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.RETURN 
    ADD CONSTRAINT RETURN_PK PRIMARY KEY ( RETURN_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE purchase_record_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.PURCHASE_RECORD 
    ( 
     PURCHASE_RECORD_ID NUMBER  DEFAULT purchase_record_seq.nextval NOT NULL , 
     SELLER_ID          NUMBER  NOT NULL , 
     ITEM_ID            NUMBER  NOT NULL , 
     PURCHASE_PRICE     FLOAT  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.PURCHASE_RECORD 
    ADD CONSTRAINT PURCHASE_RECORD_PK PRIMARY KEY ( PURCHASE_RECORD_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE seller_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.SELLER 
    ( 
     SELLER_ID NUMBER  DEFAULT seller_seq.nextval NOT NULL , 
     USER_ID   NUMBER  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.SELLER 
    ADD CONSTRAINT SELLER_PK PRIMARY KEY ( SELLER_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE promotion_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.PROMOTION 
    ( 
     PROMOTION_ID   NUMBER  DEFAULT promotion_seq.nextval NOT NULL , 
     ITEM_ID        NUMBER  NOT NULL , 
     DISCOUNT_PRICE FLOAT  NOT NULL , 
     START_DATE     TIMESTAMP  NOT NULL , 
     END_DATE       TIMESTAMP  NOT NULL 
    ) 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.PROMOTION 
    ADD CONSTRAINT PROMOTION_PK PRIMARY KEY ( PROMOTION_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE owner_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.OWNER 
    ( 
     OWNER_ID  NUMBER  DEFAULT owner_seq.nextval NOT NULL , 
     FIRSTNAME VARCHAR2 (50)  NOT NULL , 
     LASTNAME  VARCHAR2 (50)  NOT NULL , 
     USERNAME  VARCHAR2 (50)  NOT NULL , 
     EMAIL     VARCHAR2 (50)  NOT NULL , 
     PHONE     NUMBER  NOT NULL 
    ) 
    TABLESPACE DATA 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.OWNER 
    ADD CONSTRAINT OWNER_PK PRIMARY KEY ( OWNER_ID ) 
    USING INDEX LOGGING;


-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
CREATE SEQUENCE admin_seq START WITH 1;

-------------------------------------------------------------------------------------------
CREATE TABLE ADMIN.ADMIN 
    ( 
     ADMIN_ID  NUMBER  DEFAULT admin_seq.nextval NOT NULL , 
     FIRSTNAME VARCHAR2 (50)  NOT NULL , 
     LASTNAME  VARCHAR2 (50)  NOT NULL , 
     USERNAME  VARCHAR2 (50)  NOT NULL , 
     EMAIL     VARCHAR2 (50)  NOT NULL , 
     PHONE     NUMBER  NOT NULL 
    ) 
    TABLESPACE DATA 
    LOGGING;

-------------------------------------------------------------------------------------------
ALTER TABLE ADMIN.ADMIN 
    ADD CONSTRAINT ADMIN_PK PRIMARY KEY ( ADMIN_ID ) 
    USING INDEX LOGGING;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

-- USERS 
insert into ADMIN."USER" 
values(user_seq.nextval, 'Caleb', 'Landis', 'caleb765', 'caleb765landis@iu.edu', 7657657655);

insert into ADMIN."USER"
values(user_seq.nextval, 'Kratos', 'Spartan', 'gow', 'icyAxe@gmail.com', 1231234567);

insert into ADMIN."USER"
values(user_seq.nextval, 'Master', 'Chief', 'spartan117', 'masterChief@gmail.com', 1171171177);

insert into ADMIN."USER"
values(user_seq.nextval, 'Nurse', 'Joy', 'Blissey', 'nJoy@pc.com', 9998887777);


-- ORDERS
insert into ADMIN."ORDER"
values(order_seq.nextval, 1, TO_DATE('02/27/2023', 'mm/dd/yyyy'), TO_DATE('03/01/23', 'mm/dd/yyyy'), 100.55, 1, 1, 'Standard');

insert into ADMIN."ORDER"
values(order_seq.nextval, 2, TO_DATE('02/24/2023', 'mm/dd/yyyy'), TO_DATE('02/28/23', 'mm/dd/yyyy'), 45.45, 2, 2, 'Express');

insert into ADMIN."ORDER"
values(order_seq.nextval, 3, TO_DATE('02/26/2023', 'mm/dd/yyyy'), TO_DATE('02/26/23', 'mm/dd/yyyy'), 20.99, 3, 3, 'Same Day');

insert into ADMIN."ORDER"
values(order_seq.nextval, 1, TO_DATE('01/27/2023', 'mm/dd/yyyy'), TO_DATE('02/11/23', 'mm/dd/yyyy'), 100.55, 1, 1, 'Standard');


-- ORDER DETAILS
insert into ADMIN.ORDER_DETAIL
values(order_detail_seq.nextval, 1, 1);

insert into ADMIN.ORDER_DETAIL
values(order_detail_seq.nextval, 2, 2);

insert into ADMIN.ORDER_DETAIL
values(order_detail_seq.nextval, 3, 3);

insert into ADMIN.ORDER_DETAIL
values(order_detail_seq.nextval, 3, 4);

insert into ADMIN.ORDER_DETAIL
values(order_detail_seq.nextval, 4, 9);


-- PAYMENTS
insert into ADMIN.PAYMENT
values(payment_seq.nextval, 1, 1111222233334444, TO_DATE('05/27', 'mm/yy'), 123);

insert into ADMIN.PAYMENT
values(payment_seq.nextval, 2, 5555666677778888, TO_DATE('06/28', 'mm/yy'), 456);

insert into ADMIN.PAYMENT
values(payment_seq.nextval, 3, 9999000011112222, TO_DATE('07/26', 'mm/yy'), 789);


-- SHIPPING INFO
insert into ADMIN.SHIPPING_INFO
values(shipping_info_seq.nextval, 1, '100 W. Street Rd.', 'Apt. 3', 'Indianapolis', 1);

insert into ADMIN.SHIPPING_INFO
values(shipping_info_seq.nextval, 2, '200 N. War St.', NULL, 'Anchorage', 2);

insert into ADMIN.SHIPPING_INFO
values(shipping_info_seq.nextval, 3, '300 UNSC Way', NULL, 'Las Vegas', 3);


-- STATES
insert into ADMIN.STATE
values(state_seq.nextval, 'Indiana');

insert into ADMIN.STATE
values(state_seq.nextval, 'Alaska');

insert into ADMIN.STATE
values(state_seq.nextval, 'Nevada');


-- ITEMS
insert into ADMIN.ITEM
values(item_seq.nextval, NULL, 1, 100.55, 0);

insert into ADMIN.ITEM
values(item_seq.nextval, NULL, 2, 45.45, 0);

insert into ADMIN.ITEM
values(item_seq.nextval, 1, NULL, 15.55, 0);

insert into ADMIN.ITEM
values(item_seq.nextval, 2, NULL, 5.44, 0);

insert into ADMIN.ITEM
values(item_seq.nextval, 3, NULL, 60.00, 1);

insert into ADMIN.ITEM
values(item_seq.nextval, 3, NULL, 60.00, 1);

insert into ADMIN.ITEM
values(item_seq.nextval, 4, NULL, 60.00, 1);

insert into ADMIN.ITEM
values(item_seq.nextval, 4, NULL, 60.00, 1);

insert into ADMIN.ITEM
values(item_seq.nextval, NULL, 3, 100.55, 1);


-- CONSOLES
insert into ADMIN.CONSOLE
values(console_seq.nextval, 'Playstation 4', 'Sony');

insert into ADMIN.CONSOLE
values(console_seq.nextval, 'Game Boy Advance', 'Nintendo');

insert into ADMIN.CONSOLE
values(console_seq.nextval, 'Xbox Series S', 'Xbox');


-- GAMES
insert into ADMIN.GAME
values(game_seq.nextval, 'Halo Infininite', '343 Industries');

insert into ADMIN.GAME 
values(game_seq.nextval, 'Halo: Reach', 'Bungie');

insert into ADMIN.GAME 
values(game_seq.nextval, 'Pokemon: Scarlet', 'Game Freak');

insert into ADMIN.GAME 
values(game_seq.nextval, 'Pokemon: Violet', 'Game Freak');


-- RETURNS
insert into ADMIN.RETURN
values(return_seq.nextval, 5);


-- PURCHASE RECORDS
insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 1, 50.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 2, 20.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 3, 10.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 4, 2.50);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 5, 30.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 6, 30.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 7, 30.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 8, 30.00);

insert into ADMIN.PURCHASE_RECORD
values(purchase_record_seq.nextval, 1, 9, 50.00);


-- SELLERS
insert into ADMIN.SELLER
values(seller_seq.nextval, 4);


-- PROMOTIONS
insert into ADMIN.PROMOTION
values(promotion_seq.nextval, 5, 45.00, TO_DATE('02/27/2023', 'mm/dd/yyyy'), TO_DATE('03/06/2023', 'mm/dd/yyyy'));

insert into ADMIN.PROMOTION
values(promotion_seq.nextval, 6, 45.00, TO_DATE('02/27/2023', 'mm/dd/yyyy'), TO_DATE('03/06/2023', 'mm/dd/yyyy'));

insert into ADMIN.PROMOTION
values(promotion_seq.nextval, 7, 45.00, TO_DATE('02/27/2023', 'mm/dd/yyyy'), TO_DATE('03/06/2023', 'mm/dd/yyyy'));

insert into ADMIN.PROMOTION
values(promotion_seq.nextval, 8, 45.00, TO_DATE('02/27/2023', 'mm/dd/yyyy'), TO_DATE('03/06/2023', 'mm/dd/yyyy'));


-- OWNERS
insert into ADMIN.OWNER 
values(user_seq.nextval, 'Reggie', 'Fils-Aime', 'bowser', 'mariolovespeach@nintendo.com', 4321112222);


-- ADMINS
insert into ADMIN.ADMIN
values(user_seq.nextval, 'Caleb', 'Landis', 'callandi', 'callandi@iu.edu', 7657657655);


select * from "USER";
select * from "ORDER";
select * from ORDER_DETAIL;
select * from PAYMENT;
select * from SHIPPING_INFO;
select * from STATE;
select * from ITEM;
select * from CONSOLE;
select * from GAME;
select * from RETURN;
select * from SELLER;
select * from PURCHASE_RECORD;
select * from PROMOTION;
select * from OWNER;
select * from ADMIN;