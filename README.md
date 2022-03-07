To start project

    dart run

Get all words

    GET http://127.0.0.1:4044/words

    {
        "length": 1672,
        "language": "tr",
        "words": [ ... ]
    }
    
Get random word

    GET http://127.0.0.1:4044/random
    
    {
        "word": "kredi",
        "length": 5,
        "starts_with": "K",
        "letters": [
            "K",
            "r",
            "e",
            "d",
            "i"
        ]
    }

