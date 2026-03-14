/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // add field
  collection.fields.addAt(9, new Field({
    "hidden": false,
    "id": "date713973125",
    "max": "",
    "min": "",
    "name": "date_debut_commercialisation",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // add field
  collection.fields.addAt(10, new Field({
    "hidden": false,
    "id": "date1874818950",
    "max": "",
    "min": "",
    "name": "date_fin_commercialisation",
    "presentable": false,
    "required": false,
    "system": false,
    "type": "date"
  }))

  // add field
  collection.fields.addAt(11, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text1007022281",
    "max": 0,
    "min": 0,
    "name": "distributeurs",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(12, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text3722095330",
    "max": 0,
    "min": 0,
    "name": "zone_geographique_de_vente",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(13, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text452101428",
    "max": 0,
    "min": 0,
    "name": "risques_encourus",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(14, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text2286552982",
    "max": 0,
    "min": 0,
    "name": "preconisations_sanitaires",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(15, new Field({
    "autogeneratePattern": "",
    "hidden": false,
    "id": "text4167933899",
    "max": 0,
    "min": 0,
    "name": "conduites_a_tenir_par_le_consommateur",
    "pattern": "",
    "presentable": false,
    "primaryKey": false,
    "required": false,
    "system": false,
    "type": "text"
  }))

  // add field
  collection.fields.addAt(16, new Field({
    "exceptDomains": null,
    "hidden": false,
    "id": "url766584498",
    "name": "liens_vers_les_images",
    "onlyDomains": null,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "url"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // remove field
  collection.fields.removeById("date713973125")

  // remove field
  collection.fields.removeById("date1874818950")

  // remove field
  collection.fields.removeById("text1007022281")

  // remove field
  collection.fields.removeById("text3722095330")

  // remove field
  collection.fields.removeById("text452101428")

  // remove field
  collection.fields.removeById("text2286552982")

  // remove field
  collection.fields.removeById("text4167933899")

  // remove field
  collection.fields.removeById("url766584498")

  return app.save(collection)
})
