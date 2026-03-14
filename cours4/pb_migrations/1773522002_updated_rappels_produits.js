/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // update field
  collection.fields.addAt(16, new Field({
    "exceptDomains": null,
    "hidden": false,
    "id": "url766584498",
    "name": "lien_vers_affichette_pdf",
    "onlyDomains": null,
    "presentable": false,
    "required": false,
    "system": false,
    "type": "url"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2162793822")

  // update field
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
})
