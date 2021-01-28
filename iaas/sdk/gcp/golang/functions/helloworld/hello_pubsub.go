package helloworld

import (
    "context"
    "log"
)

type PubSubMessage struct {
    Data []byte `json:"data"`
}

func HelloPubSub(ctx context.Context, m PubSubMessage) error {
    name := string(m.Data) // Automatically decoded from base64.
    if name == "" {
        name = "World"
    }
    log.Printf("Hello, %s!", name)
    return nil
}
