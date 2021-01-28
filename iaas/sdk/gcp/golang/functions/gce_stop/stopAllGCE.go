package functions

import (
    "context"
    "log"

)

type PubSubMessage struct {
	Data []byte `json:"data"`
}

func StopAllGCEs(ctx context.Context, m PubSubMessage) error {
    gces, err := getInstances(ctx)
    if err != nil {
        return err
    }
    for _, g := range(gces) {
        log.Println("stop gce: ", g.Name)
        err = stopGCE(g, ctx)
        if err != nil {
            log.Println("error stog ", g.Name , " gce instance" )
            log.Println(err)
            return err
        }
    }

    log.Println("Finish Stopping Task")
    return nil
}
