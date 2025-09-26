/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A Playground for testing Foundation Models framework features.
*/

import FoundationModels
import Playgrounds

#Playground {
    let instructions = """
        Your job is to create an itinerary for the user.
        Each day needs an activity, hotel and restaurant.

        Always include a title, a short description, and a day-by-day plan.
        """
    
    // Instructions are provided by the developer
    // Prompts are provided by the user
    let session = LanguageModelSession(instructions: instructions)
    
    let kidFriendly = true

    // The Prompt builder allows for conditional logic.
    let prompt = Prompt {
        "Generate a 3-day itinerary to the Grand Canyon."
        if kidFriendly {
            "The itinerary must be kid-friendly."
            
            "Here is an example of the desired format, but don't copy its content:"
            Itinerary.exampleTripToJapan
            // Directly injecting the example into the prompt
        }
    }
    
    let response = try await session.respond(to: prompt,
                                             generating: Itinerary.self)
    // Slight delay on the first time - on-device LLM needs to load model into memory
    // Data output is completely private.
}

#Playground {
    let landmark = ModelData.landmarks[0]
    
    // Create the `Tool` with the landmark
    let pointOfInterestTool = FindPointsOfInterestTool(landmark: landmark)
    
    let instructions = Instructions {
        "Your job is to create an itinerary for the user."
        "For each day, you must suggest one hotel and one restaurant."
        "Always use the 'findPointsOfInterest' tool to find hotels and restaurant in \(landmark.name)"
        // Tells the model to invoke the Tool to always get results
    }
    
    let session = LanguageModelSession(
        tools: [pointOfInterestTool], // Pass in the tool
        instructions: instructions
    )
    
    let prompt = Prompt {
        "Generate a 3-day itinerary to \(landmark.name)."
        "Give it a fun title and description."
    }
    
    let response = try await session.respond(to: prompt,
                                             generating: Itinerary.self,
                                             options: GenerationOptions(sampling: .greedy)) // Greedy means we want consistent, deterministic output
    
    let inspectSession = session
}
