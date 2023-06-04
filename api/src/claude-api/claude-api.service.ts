import {
  AI_PROMPT,
  Client,
  CompletionResponse,
  HUMAN_PROMPT,
  SamplingParameters,
  
} from '@anthropic-ai/sdk';

import { Injectable } from '@nestjs/common/decorators/core';

@Injectable()
export class ClaudeApiService {
  private client: Client;
  constructor() {
    const apiKey = process.env.CLAUDE_API_KEY;
    if (!apiKey) {
      throw new Error('The CLAUDE_API_KEY environment variable must be set');
    }
    this.client = new Client(apiKey);
  }

  getContext(codeContext: string, prompt: string): string {
    const PROMPT_PROJECT_SUMMARY = `
     We have code challenges for a Senior React Developer position. I would like for you to review the code, and provide an overall project overview, that can be used as context for prompts for an AI React code reviewer. I would like your response to be presented as a well structured markdown document. With the following secctions:
     - Project Overview
      - Component Structure
      - Performance Optimizations
      - Code Quality
      - Defects or Bugs
      - Code Readability & Style
      - Overview:
      -- A score for each category from 0 - 10. Acting as a Senior React developer, rate yourself from 0-10 for each category as if you had written this code.

      Important be very critical and provide a lot of details, the goal is to provide a lot of information that the Code Reviewer can make the best decision possible.
      
      Code Challenge:
      ${codeContext}
    `;

    return PROMPT_PROJECT_SUMMARY;
  }

  async codeReview(
    codeAsContext: string,
    codeToReview: string,
  ): Promise<string> {
    console.log('inside code review');
    const context = await this.getContext(codeAsContext, codeToReview);

    const prompt = `${HUMAN_PROMPT}: ${context} ${AI_PROMPT}`;

    console.log(`${prompt}`);
    const response = await this.client.complete({
      prompt: prompt,
      stop_sequences: [HUMAN_PROMPT],
      max_tokens_to_sample: 10000,
      temperature: 0.3,
      //model: 'claude-v1',
      model: 'claude-v1.3-100k',
    });

    console.log('response', response.completion);

    return response.completion;
  }

  async codeReviewChat(content: string): Promise<string> {
    console.log('inside code review');
    //const context = await this.getContext(codeAsContext, codeToReview);

    const prompt = `${HUMAN_PROMPT} ... ${AI_PROMPT}`;
    
    const response = await this.client.complete({
      prompt: content,
      stop_sequences: [HUMAN_PROMPT],
      max_tokens_to_sample: 10000,
      temperature: 0.3,
      model: 'claude-v1.3-100k',
    });
    console.log('\n\n >>>>  response >>>> ', response);
    return response.completion;
  }

  async sendToAI(aiSettings: SamplingParameters & { content?: string}): Promise<CompletionResponse> {
    
    const request = {
      prompt: aiSettings.content,
      stop_sequences: [HUMAN_PROMPT],
      max_tokens_to_sample: aiSettings.max_tokens_to_sample ??  10000,
      temperature: aiSettings.temperature ?? 0.3,
      model: aiSettings.model ?? 'claude-v1.3-100k',
    };
    console.log('request >> ', request);
    const response = await this.client.complete(request);
    console.log(response)
    return response;
  }
}
