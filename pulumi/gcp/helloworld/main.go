package main

import (
	"github.com/pulumi/pulumi-gcp/sdk/v3/go/gcp/storage"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		// Create a GCP resource (Storage Bucket)
		bucket, err := storage.NewBucket(ctx, "ca-kitano-study-sandbox-my-bucket", nil)
		if err != nil {
			return err
		}

		// Export the DNS name of the bucket
		ctx.Export("bucketName", bucket.Url)
		return nil
	})
}
