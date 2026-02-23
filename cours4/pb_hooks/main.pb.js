console.log("fichier chargé");

cronAdd("sync_rappels", "* * * * *", () => { 

    console.log("cron ok");

    let collection;

    try {
        collection = $app.findCollectionByNameOrId("rappels_produits");
    } catch (err) {
        console.log("Probleme de collection");
        return;
    }

    const res = $http.send({
        url: "https://codelabs.formation-flutter.fr/assets/rappels.json",
        method: "GET",
        timeout: 30,
    });

    if (res.statusCode !== 200) {
        console.log("Fetch error:", res.statusCode);
        return;
    }

    const items = Array.isArray(res.json) ? res.json : [];
    const today = new Date();

    $app.runInTransaction((txApp) => {

        for (let item of items) {

            const numeroFiche = item.numero_fiche;
            if (!numeroFiche) continue;

            let record = null;

            try {
                record = txApp.findFirstRecordByData(
                    "rappels_produits",
                    "numero_fiche",
                    numeroFiche
                );
            } catch (e) {
                record = null;
            }

            if (!record) {
                record = new Record(collection);
            }

            let actif = false;
            if (item.date_de_fin_de_la_procedure_de_rappel) {
                const fin = new Date(item.date_de_fin_de_la_procedure_de_rappel);
                actif = fin >= today;
            }

            record.set("numero_fiche", numeroFiche);
            record.set("gtin", item.gtin ? String(item.gtin) : "");
            record.set("libelle", item.libelle);
            record.set("marque_produit", item.marque_produit);
            record.set("motif_rappel", item.motif_rappel);
            record.set("date_publication", item.date_publication);
            record.set("date_de_fin_de_la_procedure_de_rappel", item.date_de_fin_de_la_procedure_de_rappel);
            record.set("actif", actif);

            txApp.save(record);
        }
    });

    console.log("synchro ok");
});
