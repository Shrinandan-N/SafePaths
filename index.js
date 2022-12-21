DATABASE_URL= "postgresql://Ashok:czMOGn1z2dS02HhyzZmMdw@free-tier4.aws-us-west-2.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full&options=--cluster%3Dgrim-cicada-3974"

//using cockroach DB
const Sequelize = require("sequelize-cockroachdb")
const sequelize = new Sequelize(DATABASE_URL)

//creating a location object to store
const Transfer = sequelize.define("transfer_v1", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    address: {
        type: Sequelize.TEXT,
    }
}) 

//get call to fetch a list of all the crime locations
const tr_list = async (event) => {
    try {
        const sync = await Transfer.sync({force: false})
        console.log("sync")
        console.log(sync)
        const transfer = await Transfer.findAll()
        console.log("location")
        console.log(transfer)
        return {
            statusCode: 200,
            body: JSON.stringify(transfer)
        }
    }
    catch(error) {
        console.log("error" + error)
        return {
            statusCode: 200,
            body: JSON.stringify("generic")
        }
    }
}

//post method to add crime data to the database
const tr_add = async (event) => {
    console.log("event " + event)
    if (!event["address"]){
        event = JSON.parse(event.body)
    }
    console.log(event)
    console.log(event["address"])
    return Transfer.sync({
        force: false,
    }).then(function(){
        return {
            statusCode: 200,
            body: JSON.stringify(Transfer.bulkCreate([
            {
                address: event["address"]
            }]))
        }
    })
}

const Location = sequelize.define("locations_v1", {
    id: {
        type: Sequelize.INTEGER,
        autoIncrement: true,
        primaryKey: true,
    },
    address: {
        type: Sequelize.TEXT,
    },
    longitude: {
        type: Sequelize.FLOAT,
    },
    latitude: {
        type: Sequelize.FLOAT,
    },
    crime_score: {
        type: Sequelize.INTEGER,
    }
}) 

//get call to fetch a list of all the crime locations
const list = async (event) => {
    try {
        const sync = await Location.sync({force: false})
        console.log("sync")
        console.log(sync)
        const location = await Location.findAll()
        console.log("location")
        console.log(location)
        return {
            statusCode: 200,
            body: JSON.stringify(location)
        }
    }
    catch(error) {
        console.log("error" + error)
        return {
            statusCode: 200,
            body: JSON.stringify("generic")
        }
    }
}

//post method to add crime data to the database
const add = async (event) => {
    console.log(event)
    body = JSON.parse(event.body)
    console.log(body)
    return Location.sync({
        force: false,
    }).then(function(){
        return {
            statusCode: 200,
            body: JSON.stringify(Location.bulkCreate([
            {
                address: body["address"],
                longitude: body["longitude"],
                latitude: body["latitude"],
                crime_score: body["crime_score"]
            }]))
        }
    })
}

//removes all locations from the database
const remove = async (event) => {
    console.log(Location)
    Location.drop();
    return {
        statusCode: 200,
        body: JSON.stringify(location)
    }
}

//exporting api calls
module.exports = {list, add, remove, tr_list, tr_add};