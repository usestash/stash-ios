//
//  Pasta.swift
//  StashAnalyticsDemo
//
//  Created by Ciprian Redinciuc on 20.07.2021.
//

import Foundation

struct PastaDish: Identifiable {
    var id = UUID()
    var name: String
    var region: String
    var description: String

    var imageName: String { return name }
    var thumbnailName: String { return name + "_thumbnail" }
}

let testData = [
    PastaDish(name: "Agnolini mantovani in brodo",
              region: "Lombardy",
              description: "A Mantua dish made with agnolini dumplings in broth."),
    PastaDish(name: "Bucatini all'amatriciana",
              region: "Lazio",
              description: "Traditional Amatrice dish, made with bucatini pasta, with tomatoes, guanciale, Pecorino Romano cheese and black pepper."),
    PastaDish(name: "Casoncelli",
              region: "Lombardy",
              description: "A north-Italy dish, specially from Bergamo and Brescia, with casoncelli dumplings, bacon, melted butter, sage leaves and Parmigiano-Reggiano or Grana Padano cheese."),
    PastaDish(name: "Ciceri e Tria",
              region: "Apulia",
              description: "A Salento dish prepared with pasta and chickpeas as primary ingredients."),
    PastaDish(name: "Lasagne alla napoletana",
              region: "Campania",
              description: "A Neapolitan dish of baked lasagne flat-shaped pasta, prepared with several layers of lasagne sheets alternated with ragù sauce, mozzarella cheese (or scamorza cheese)."),
    PastaDish(name: "Pasta alla Norma",
              region: "Sicily",
              description: "A dish made with a short pasta, with a sauce prepared with tomatoes, fried eggplant, grated ricotta salata cheese, and basil."),
    PastaDish(name: "Penne all’arrabbiata",
              region: "Lazio",
              description: "A Roman dish of penne pasta, with the arrabbiata sauce, a spicy sauce made from garlic, tomato, and red chili peppers cooked in olive oil (\"arrabbiata\" literally means \"angry\" in Italian; the name of the sauce refers to the spiciness of the chilli peppers)."),
    PastaDish(name: "Spaghetti aglio, olio e peperoncino",
              region: "Lazio",
              description: "A Roman dish of spaghetti pasta made by lightly sauteeing minced or pressed garlic in olive oil, sometimes with the addition of dried red chili flakes. Finely chopped parsley can also be added as a garnish."),
    PastaDish(name: "Spaghetti alla carbonara",
              region: "Lazio",
              description: "A Roman dish of spaghetti pasta, with raw eggs, Pecorino Romano cheese, bacon (guanciale or pancetta), and black pepper."),
    PastaDish(name: "Spaghetti alla puttanesca",
              region: "Campania",
              description: "A Naples dish, made with spaghetti pasta, with a tomato sauce, with anchovies, olives, capers and garlic."),
    PastaDish(name: "Spaghetti alle vongole",
              region: "Campania",
              description: "Spaghetti with clams. Prepared in two ways: in bianco, i.e., with oil, garlic, parsley, and sometimes a splash of white wine; and in rosso, like the former but with tomatoes and fresh basil.")
]
