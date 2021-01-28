package functions

import (
    "os"
    "log"
    "context"

    "google.golang.org/api/compute/v1"
)

func getZones(ctx context.Context) ([]string, error) {
	var zones []string

    sv , err := createSv(ctx)

    if err != nil {
        log.Println("error NewService")
        log.Println(err)
		return zones, err
	}

	zs := compute.NewZonesService(sv)
	zoneList, err := zs.List(os.Getenv("GCP_PROJECT")).Do()

	if err != nil {
        log.Println("error zs error")
        log.Println(err)
		return zones, err
	}

	for _, zone := range zoneList.Items {
		zones = append(zones, zone.Name)
	}

	return zones,nil
}
