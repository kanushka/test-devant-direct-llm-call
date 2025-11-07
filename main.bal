import ballerina/http;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /blogs on httpDefaultListener {
    resource function post review(@http:Payload Blog payload) returns error|Review {
        do {
            Review review = check aiWso2modelprovider->generate(`You are an expert content reviewer for a blog site that
categorizes posts under the following categories: "Gardening", "Sports", "Health", "Technology", "Travel"

Your tasks are:
1. Suggest a suitable category for the blog from exactly the specified categories.
If there is no match, use null.

2. Rate the blog post on a scale of 1 to 10 based on the following criteria:
- **Relevance**: How well the content aligns with the chosen category.
- **Depth**: The level of detail and insight in the content.
- **Clarity**: How easy it is to read and understand.
- **Originality**: Whether the content introduces fresh perspectives or ideas.
- **Language Quality**: Grammar, spelling, and overall writing quality.

Here is the blog post content:

Title: ${payload.title}
Content: ${payload.content}
`);
            return review;
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

    resource function post test(@http:Payload Blog payload) returns Review|error {
        do {
            Review review = {
                "suggestedCategory": payload.content,
                "rating": 5
            };
            return review;
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

}
