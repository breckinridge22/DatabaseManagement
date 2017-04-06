/* Beginning of File Drop Statements */

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
DROP TRIGGER IF EXISTS MapWeightsDelete;
DROP TRIGGER IF EXISTS UsersFromCADelete;
DROP TRIGGER IF EXISTS DeleteIndividual;

/*  Views  */
DROP VIEW IF EXISTS MapWeights;
DROP VIEW IF EXISTS MapSuggestions;
DROP VIEW IF EXISTS UsersFromCA;
DROP VIEW IF EXISTS HoodsOfWildlife;


/**************************** Table Definitions ******************************/

/*
/ All IDs represented by an integer value that is unique and names are
/ strings. Table represents Wildlife in database. Dangerous is boolean value
/ that represents whether wildlife is dangerous or not
*/
CREATE TABLE Wildlife (
/* prepopulated wildlife should not have any null values */
WildlifeID INTEGER PRIMARY KEY,
SciName varchar(100) NOT NULL,
CommonName varchar(100) NOT NULL,
GenericPicID INTEGER NOT NULL,
Dangerous BOOLEAN
)


/* Insert Sample Data into the WildLife TABLE here */
Insert into Wildlife values (1, "Sciurus carolinensis", "Eastern Grey Squirrel", 001, NULL);
Insert into Wildlife values (2, "Ursus americanus", "Black Bear", 002, TRUE);
Insert into Wildlife values (3, "Buteo jamaicensis", "Red-Tailed Hawk", 003, NULL);
Insert into Wildlife values (4, "Canis latrans", "Coyote", 004, TRUE);
Insert into Wildlife values (5, "Turdus migratorius", "Robin", 005, NULL);
Insert into Wildlife values (6, "Cyanocitta cristata", "Blue Jay", 006, NULL);
Insert into Wildlife values (7, "Vulpes vulpes fulvus", "American Red Fox", 007, NULL);
Insert into Wildlife values (8, "Tamias", "Chipmunk", 008, NULL);
Insert into Wildlife values (9, "Mephitidae", "Skunk", 009, TRUE);
Insert into Wildlife values (10, "Procyon lotor", "Racoon", 010, NULL);


/*
/ Association class between Individual and Picture w/ FKs on PKs of each
/ class, and if either FK is updated/deleted, changes should cascade entirely
/ through. Because of the cardinalities, the PK is both PKs from both classes
/ on either side of the association
*/
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


/*
/ Pictures taken by users.  Files are binary and the unique ID is an integer.
/ ‘Identified’ is a boolean value that determines whether the wildlife has been
/ identified or not, i.e., if user taking the picture can’t identify it then other
/ users can.  All other variable types are intuitive. Updates to FK Username
/ should cascade but deletes should be restricted since all pictures should
/ have a username associated.  FK HoodID is also the same.
*/
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
ON DELETE NO ACTION
ON UPDATE CASCADE,
FOREIGN KEY(HoodID) REFERENCES Neighborhood
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Picture TABLE here */


/*
/ Every user will have a username, email, and neighborhood. ProfPic is a
/ binary file. Every user must be associated with a neighborhood so deleting the
/ FK HoodID should be restricted; however, if a user moves, the user should be
/ able to update his/her neighborhood.
*/
CREATE TABLE User (
Username VARCHAR(60) PRIMARY KEY,
Email VARCHAR(60) NOT NULL,
ProfPic VARBINARY(MAX),
HoodID INTEGER NOT NULL,
FOREIGN KEY (HoodID) REFERENCES Neighborhood NOT NULL
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

Insert into User values("milkman35", "milkman35@hotmail.com", NULL, 123);
Insert into User values("elkgod2", "elkgod2@gmail.com", NULL, 123);
Insert into User values("iLoveSquirrels", "john.gilbert@gmail.com", NULL, 123);
Insert into User values("unBEARable", "ianscott@gmail.com", NULL, 124);
Insert into User values("imHawkward", "george.vincent@gmail.com", NULL, 124);
Insert into User values("rukittenme", "christina@hotmail.com", NULL, 124);
Insert into User values("instaham", "youknowwho@hotmail.com", NULL, 125);
Insert into User values("theGoat", "tombrady@gmail.com", NULL, 125);
Insert into User values("pugtato", "doglover@gmail.com", NULL, 125);
Insert into User values("hipsterpotamus", "realclever@gmail.com", NULL, 126);
Insert into User values("movesLikeJaguar", "mick@hotmail.com", NULL, 126);
Insert into User values("youAreirrelephant", "jlow23@gmail.com", NULL, 126);



/* Insert Sample Data into the User TABLE here */



/*
/ Represents the friend relationship between two users.  The relationship
/ should be unique; therefore, both users are the PK referenced from the User
/ table. The relationship on delete/update should cascade
*/
CREATE TABLE Friend (
User1 VARCHAR(60),
User2 VARCHAR(60),
PRIMARY KEY (User1, User2),
FOREIGN KEY (User1) REFERENCES User
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (User2) REFERENCES User
	ON DELETE CASCADE
	ON UPDATE CASCADE

/* Insert Sample Data into the Friend TABLE here
/
/
/
*/


/*
/ Represents a neighborhood.  HoodID uniquely identifies the neighborhood
/ and each neighborhood has to be associated with a specific city, but if
/ boundaries changes then the city can be updated accordingly.
*/
CREATE TABLE Neighborhood (
HoodID INTEGER PRIMARY KEY,
HoodName  VARCHAR(60) NOT NULL,
CityID INTEGER NOT NULL,
FOREIGN KEY (CityId) REFERENCES City
	ON DELETE NO ACTION
	ON UPDATE CASCADE
)

/* Insert Sample Data into the Nieghbordhood TABLE here */
Insert into Neighborhood Values (123, "12 South", 001);
Insert into Neighborhood Values (124, "Edgehill", 001);
Insert into Neighborhood Values (125, "Hillsboro Village", 001);
Insert into Neighborhood Values (126, "Green Hills", 001);
Insert into Neighborhood Values (127, "West End", 001);


/*
/ Represents a city uniquely identified with an integer ID. Cities must
/ have a name and an associated state.
*/
CREATE TABLE City (
CityID INTEGER PRIMARY KEY,
Name VARCHAR(60) NOT NULL,
State VARCHAR(60) NOT NULL
)

Insert into City Values (001, "Nashville", "Tennessee");
Insert into City Values (002, "Knoxville", "Tennessee");
Insert into City Values (003, "Memphis", "Tennessee");
Insert into City Values (004, "Johnson City", "Tennessee");
Insert into City Values (005, "Murfreesboro", "Tennessee");

/* Insert Sample Data into the City TABLE here
/
/
/
*/


/*
/ Represents a comment uniquely identified by an integer ID. Comments must
/ have a message in them and users can like comments which is kept in an
/ integer counter variable.  Comments are on pictures, so there is an associated
/ PicID for the picture the comment is in relation to. Each comment must be
/ timestamped and a specific user must be identified with each comment.
/ If a user deletes his/her profile, then that will cascade to all of his/her
/ comments. Likewise, if the user changes his/her username, then the changes
/ will cascade.
*/
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


/*
/ Relationship between comments. Allows response to comments.
/ ChildCommentID represents the responding comment and ParentCommentID
/ represents the comment that the child comment is responding to. If any of
/ the comments are deleted or edited, those changes will cascade through.
*/
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


/*
/ Represents individual wildlife, i.e., Joe the Squirrel.  Identified by a
/ unique integer ID and will have a name associated with it, i.e., Joe.  It
/ will be associated with the specific wildlife via the referenced WildlifeID.
/ The individual needs to have a wildlife associated with it, so that it isn’t
/ a dangling individual w/o a specific wildlife attached to it; therefore,
/ deletions of WildlifeID are restricted, but updates will cascade if it turns
/ out, for example, that Joe is not a squirrel.
*/
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


/*
/ After adding a friend into Friend this Trigger adds the inverse
/ Tuple to the Friend relation.
*/
CREATE TRIGGER AddFriend (
AFTER INSERT ON Friend
FOR EACH ROW
BEGIN
	INSERT INTO Friend VALUES(New.ID2, New.ID1);
END;
)


/*
/ Rationale: create view that associates each longitude and latitude with the
/ number of pics of a given neighborhood chosen by users. Data used for
/ processing the number of reported neighborhoods at a specific latitude and longitude.
/ Security: This view is not displayed to the user. Used in back-end systems
/ for processing data boundaries.
*/
CREATE VIEW MapWeights
AS
	SELECT P.Longitude, P.Latitude, N.HoodID, COUNT(P.PicID)
	FROM Picture P, Neighborhood N
	GROUP BY P.Longitude, P.Latitude
HAVING P.HoodID = N.HoodID;

/* when deleting from MapWeights, delete all Pictures with same Longitude, Latitude, and reported HoodID */
CREATE TRIGGER MapWeightsDelete
ON MapWeights
INSTEAD OF DELETE AS
BEGIN
	DELETE FROM Picture
	WHERE Old.Longitude = Picture.Longitude
	      AND Old.Latitude = Picture.Latitude;
	      AND Old.HoodID = Picture.HoodID
END;

/*
/ Rationale: create view that associates each longitude and latitude with the
/ neighborhood with the most amount of user chosen neighborhoods associated
/ with it. Used for developing neighborhood boundaries.
/ Security: This view is not displayed to the user. This is for the backend
/ to try and suggest boundaries.
*/
CREATE VIEW MapSuggestion
AS
	SELECT P.Longitude, P.Latitude, P.HoodID
	FROM Picture P
	GROUP BY P.Longitude, P.Latitude
HAVING COUNT(P.HoodID) = MAX(
SELECT COUNT(P1.PicID)
FROM Picture P1
Where P1.HoodID = P.HoodID);
/* cannot delete, update, or remove from MapSuggestion */

/*
/ Rationale: This does not have to be backend. This can allow users to search
/ for another user and narrow them down to a user from California for adding friend purposes.
/ Security: User should not be able to see detailed information about the other user’s metadata
/ and should not have to see detailed metadata such as CityID and HoodID.
*/
CREATE VIEW UsersFromCA
AS
	SELECT Username
	FROM User, Neighborhood, City
	WHERE User.HoodID = Neighborhood.HoodID
	      AND Neighborhood.CityID = City.CityID
      	AND City.State = ‘CA’;

/* */
CREATE TRIGGER UsersFromCADelete
ON UsersFromCA
INSTEAD OF Delete AS
BEGIN
	DELETE From User
	Where Old.username=User.username
			  AND Old.Email=User.email
			  AND Old.ProfPic=User.ProfPic
			  AND Old.HoodID=User.HoodID
END;


/*
/ List Neighborhoods where specific individual named “Joe the Squirrel” has been seen
/ Rationale: List neighborhoods where a specific individual
/ (e.g. “Joe the Squirrel” w/ ID 163256) has been seen.
/ Security: IndividualID is associated with a specific wildlife.
/ These attributes are okay to share with the user.
*/
CREATE VIEW HoodsOfWildlife
AS
	SELECT Neighborhood.HoodName, IndividualID
	FROM Neighborhood, Appears, Picture
	WHERE Individual.ID = 163256
			   AND Appears.PicID = Picture.PicID
			   AND Picture.HoodID = Neighborhood.HoodID;

/* On deletion from HoodsOfWildlife, delete Individual from Appears */
CREATE TRIGGER DeleteIndividual
ON HoodsOfWildlife
INSTEAD OF DELETE AS
BEGIN
		DELETE FROM Appears
		WHERE Old.IndividualID = IndividualID;
END;

/****************************** Assertions ***********************************/

/* a picture cannot have more than 100 comments */
CREATE ASSERTION CommentMax
CHECK NOT EXISTS(	SELECT COUNT(*)
				FROM Comment
				GROUP BY PicID
				HAVING COUNT(CommentID) > 100);

CREATE ASSERTION CommentChain
CHECK (NOT EXISTS(	SELECT R1.ParentCommentID
				FROM Respond R1
				WHERE R1.ChildCommentID IN (SELECT R2.ParentCommentID
																		FROM Respond R2
																		WHERE R2.ParentCommentID = R1.ChildCommentID
																		 			AND R2.ChildCommentID IN (SELECT R3.ParentCommentID
																																		FROM Respond R3
																																		WHERE R3.ParentCommentID = R2.ChildCommentID )))
/* Make Sure Each City has at least 1 Neighborhood */
CREATE ASSERTION CityNeighborhoods
CHECK (NOT EXISTS(SELECT City.CityID FROM City
									WHERE City.CityID NOT IN (SELECT Neighborhood.CityID
									FROM Neighborhood)))


/************************** Modification Statements **************************/

INSERT INTO User
VALUES ((‘ilovenature’, ‘ilovenature@gmail.com’, 0h202020, 123));

DELETE FROM Comment
WHERE CommentID = 123;

UPDATE Comment
SET Comment.Username = New.Username
WHERE Comment.CommentID = Old.CommentID;

UPDATE User
SET User.HoodID = New.HoodID
WHERE User.Username = Old.Username;

UPDATE Neighborhood
SET Neighborhood.CityID = New.CityID
WHERE Neighborhood.HoodID = Old.HoodID;

UPDATE Individual
SET Individual.WildlifeID = New.WildlifeID
WHERE Individual.IndividualID = Old.IndividualID;

DELETE FROM Picture
WHERE PicID = Old.PicID;


/******************************* Queries *************************************/

/* Number of wildlife seen in a certain Neighborhood */
SELECT COUNT(WildlifeID)
FROM Neighborhood, Appears, Wildlife, Picture, Individual
WHERE Wildlife.WildlifeID = Individual.WildlifeID
      AND Individual.IndividualID = Appears.IndividualID
      AND Appears.PicID = Picture.PicID
      AND Picture.HoodID = Neighborhood.HoodID
GROUP BY Neighborhood.HoodID;

/* Display Neighborhood with most Users */
SELECT HoodID, COUNT(*) as countUsers
FROM User
GROUP BY HoodID
HAVING COUNT(*) = MAX(
	SELECT count(Username)
	FROM User
	GROUP BY HoodID);

/* Display Neighborhood with least Users */
SELECT HoodID, COUNT(*) as countUsers
FROM User
GROUP BY HoodID
HAVING COUNT(*) = MIN(
		SELECT count(Username)
		FROM User
		GROUP BY HoodID);

/* Display number of unique wildlife from a user */
SELECT User.Username, COUNT(distinct WildlifeID) as NumUnique
FROM User, Picture, Appears
WHERE User.Username = Picture.Username and Picture.PicID = Appears.PicID
GROUP BY User.Username;

/* Display User with most comments */
SELECT Comment.Username
FROM Comment
GROUP BY Comment.Username
HAVING COUNT(CommentID) = MAX(
	   SELECT COUNT(CommentID)
	   FROM Comment
	   GROUP BY Comment.Username);

/*How many pictures in a given neighborhood (e.g. "Edgehill" from Nashville and not another city’s Brentwood) */
SELECT COUNT(distinct PicID)
FROM Picture, Neighborhood, City
WHERE Picture.HoodID = Neighborhood.HoodID and Neighborhood.HoodName= "Edgehill"
 			and City.CityID=Neighborhood.CityID and City.Name=”Nashville”
GROUP BY Neighborhood.HoodID;

/*How many Neighborhoods in Nashville */
SELECT COUNT(Neighborhood.HoodID)
FROM Neighborhood, City
WHERE Neighborhood.CityID=City.CityID and City.Name=”Nashville”
GROUP BY City.CityID;

/*Wildlife with most users seen by i.e. Most commonly seen wildlife. This will be done by counting the pictures and assumes user always takes a picture of a wildlife they see and list wildlife from most users, descending */
SELECT Wildlife.CommonName, COUNT(User.username) as count
FROM User, Appears, Picture, Wildlife
WHERE User.username=Picture.username and Picture.PicID=Appears.PicID and Appears.IndividualID = Individual.IndividualID and Individual.WildlifeID = Wildlife.WildlifeID
GROUP BY Wildlife.WildlifeID
ORDER BY count DESC;

/* Number of users in each neighborhood */
SELECT Neighborhood.HoodName, COUNT(User.username)
FROM Neighborhood, User
WHERE User.HoodID = Neighborhood.HoodID
GROUP BY Neighborhood.HoodID;

/* List of users in each neighborhood */
SELECT Neighborhood.HoodName, User.username
FROM Neighborhood, User
WHERE User.HoodID = Neighborhood.HoodID
GROUP BY Neighborhood.HoodID;

/* User with the Most friends */
SELECT User.Username
FROM User, Friend
WHERE User.Username = Friend.ID1
GROUP BY User.Username
HAVING COUNT(*) = MAX(SELECT COUNT(ID2)
			FROM Friend
GROUP BY ID1);

/* Picture with the most Comments */
SELECT PicID
FROM Comment
GROUP BY PicID
HAVING COUNT(CommentID) = MAX(
	SELECT count(CommentID)
	FROM Comment
	GROUP BY PicID);

/* Users with least friends */
SELECT User.Username
FROM User, Friend
WHERE User.Username = Friend.ID1
GROUP BY User.Username
HAVING COUNT(*) = MIN(SELECT count(ID2)
			FROM Friend
GROUP BY ID1);

/* Picture with the least Comments */
SELECT PicID
FROM Comment
GROUP BY PicID
HAVING COUNT(CommentID) = MIN(
	SELECT COUNT(CommentID)
	FROM Comment
	GROUP BY PicID);


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
DROP TRIGGER IF EXISTS MapWeightsDelete;
DROP TRIGGER IF EXISTS UsersFromCADelete;
DROP TRIGGER IF EXISTS DeleteIndividual;

/*  Views  */
DROP VIEW IF EXISTS MapWeights;
DROP VIEW IF EXISTS MapSuggestions;
DROP VIEW IF EXISTS UsersFromCA;
DROP VIEW IF EXISTS HoodsOfWildlife;
