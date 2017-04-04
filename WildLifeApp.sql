

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Wildlife;

CREATE TABLE Wildlife (
/* prepopulated wildlife should not have any null values */
WildlifeID INTEGER PRIMARY KEY,
SciName varchar(100) NOT NULL,
CommonName varchar(100) NOT NULL,
GenericPicID INTEGER NOT NULL
)

/* Insert Sample Data into the WildLife TABLE here
/
/
/
*/


/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Appears;

CREATE TABLE  Appears (
IndividualID INTEGER,
PicID INTEGER,
PRIMARY KEY (IndividualID, PicID),
FOREIGN KEY (IndividualID) REFERENCES Individual
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (PicID) REFERENCES Picture
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Appears TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Picture;

CREATE TABLE Picture (
PicID INTEGER PRIMARY KEY,
PicFile VARBINARY(MAX),
Identified BOOLEAN,
Username VARCHAR(60) NOT NULL,
Longitude DECIMAL(13,5) NOT NULL,
Latitude DECIMAL (13,5) NOT NULL,
DateSeen DATE NOT NULL,
TimeSeen DATE NOT NULL,
HoodID INTEGER NOT NULL,
FOREIGN KEY(Username) REFERENCES User
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY(HoodID) REFERENCES Neighborhood
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Picture TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS User;

CREATE TABLE User (
Username VARCHAR(60) PRIMARY KEY,
Email VARCHAR(60) NOT NULL,
ProfPic VARBINARY(MAX),
HoodID INTEGER NOT NULL,
FOREIGN KEY (HoodID) REFERENCES Neighborhood NOT NULL
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the User TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Friend;

CREATE TABLE Friend (
ID1 INT,
ID2 INT,
PRIMARY KEY (ID1, ID2),
FOREIGN KEY (ID1) REFERENCES User
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (ID2) REFERENCES User
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Friend TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Niehgbordhood;

CREATE TABLE Neighborhood (
HoodID INTEGER PRIMARY KEY,
HoodName  VARCHAR(60) NOT NULL,
CityID INTEGER NOT NULL,
FOREIGN KEY (CityId) REFERENCES City
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Nieghbordhood TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS City;

CREATE TABLE City (
CityID INTEGER PRIMARY KEY,
Name VARCHAR(60) NOT NULL,
State VARCHAR(60) NOT NULL
)

/* Insert Sample Data into the City TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Comment;

CREATE TABLE Comment (
CommentID INTEGER PRIMARY KEY,
Message VARCHAR(140) NOT NULL,
LikeCount INTEGER,
PicID INTEGER NOT NULL,
Username VARCHAR(60) NOT NULL,
Date DATE NOT NULL,
Time DATE NOT NULL,
FOREIGN KEY(PicID) REFERENCES Picture
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY(Username) REFERENCES User
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Comment TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Respond;

CREATE TABLE Respond (
ParentCommentID INTEGER,
ChildCommentID INTEGER PRIMARY KEY,
FOREIGN KEY (ParentCommentID) REFERENCES Comment
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (ChildCommentID) REFERENCES Comment
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Respond TABLE here
/
/
/
*/

/* DROP TABLE if already exists */
DROP TABLE IF EXISTS Individual;

CREATE TABLE Individual (
IndividualID INTEGER PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
WildlifeID INTEGER NOT NULL,
FOREIGN KEY(WildlifeID) REFERENCES Wildlife
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Individual table here
/
/
/
*/

/* DROP TRIGGER IF EXISTS already */
DROP TRIGGER IF EXISTS DeleteFriend;


/* Delete friend from both sides of the friendship */
CREATE TRIGGER DeleteFriend (
AFTER DELETE ON Friend
FOR EACH ROW
BEGIN
	DELETE FROM Friend
	WHERE Friend.ID1 = OLD.ID2
	      AND Friend.ID2 = OLD.ID1;
END;
)

/* DROP TRIGGER IF EXISTS already */
DROP TRIGGER IF EXISTS AddFriend;

/* After adding a friend into Friend adds the inverse Tuple to the Friend relation*/
CREATE TRIGGER AddFriend (
AFTER INSERT ON Friend
FOR EACH ROW
BEGIN
	INSERT INTO Friend VALUES(New.ID2, New.ID1);
END;
)

/* DROP VIEW IF EXISTS already */
DROP VIEW IF EXISTS PicCounts;

/* create VIEW that associates each longitude and latitude with the number of a given neighborhood chosen by users
/
/ **** Need more documentation ****
/
*/
CREATE VIEW PicCounts
AS
	SELECT P.Longitude, P.Latitude, N.HoodID, count(P.PicID)
	FROM Picture P, Neighborhood N
	GROUP BY P.Longitude, P.Latitude
HAVING P.HoodID = N.HoodID;


/* DROP VIEW IF EXISTS already */
DROP VIEW IF EXISTS MapWeights;

/* create VIEW that associates each longitude and latitude with the neighborhood with the most amount of user chosen neighborhoods associated with it
/
/ ***** Need More documentation *****
/
/
*/
CREATE VIEW MapWeights
AS
	SELECT P.Longitude, P.Latitude, P.HoodID
	FROM Picture P
	GROUP BY P.Longitude, P.Latitude
HAVING COUNT(P.HoodID) = max(
SELECT count(P1.PicID)
From Picture P1
Where P1.HoodID = P.HoodID);

/* DROP VIEW IF EXISTS already */
DROP VIEW IF EXISTS UsersFromCA;

/* Users who are in CA
/
/  **** Need more documentation ****
/
/
*/

CREATE VIEW UsersFromCA
AS
	SELECT Username
	FROM User, Neighborhood, City
	WHERE User.HoodID = Neighborhood.HoodID
	      AND Neighborhood.CityID = City.CityID
      AND City.State = ‘CA’;


/* DROP VIEW IF EXISTS already */
DROP VIEW IF EXISTS HoodsOfWildlife;

/* List Neighborhoods where specific individual named “Joe the Squirrel” has been seen
/
/ ***** Need more documentation *****
/
/
*/
CREATE VIEW HoodsOfWildlife
AS
	SELECT Neighborhood.HoodName
	FROM Neighborhood, Appears, Picture
	WHERE Individual.Name = “Joe the Squirrel”
	     AND Appears.PicID = Picture.PicID
	     AND Picture.HoodID = Neighborhood.HoodID;



/* Queries Go Here */




/* End of File Drop Statements */

/* Tables */
DROP TABLE IF EXISTS Wildlife;
DROP TABLE IF EXISTS Appears;
DROP TABLE IF EXISTS Picture;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Friend;
DROP TABLE IF EXISTS Niehgbordhood;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Respond;
DROP TABLE IF EXISTS Individual;

/*  Triggers  */
DROP TRIGGER IF EXISTS DeleteFriend;
DROP TRIGGER IF EXISTS AddFriend;

/*  Views  */
DROP VIEW IF EXISTS PicCounts;
DROP VIEW IF EXISTS MapWeights;
DROP VIEW IF EXISTS UsersFromCA;
DROP VIEW IF EXISTS HoodsOfWildlife;
