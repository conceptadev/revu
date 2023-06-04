import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as express from 'express';
import * as bodyParser from 'body-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(express.json({ limit: '1000mb' })); // Adjust the limit as per your requirements

  // Configure body-parser to increase payload size limit
  app.use(bodyParser.json({ limit: '1000mb' }));
  app.use(bodyParser.urlencoded({ limit: '1000mb', extended: true }));
  app.enableCors();
  await app.listen(process.env.PORT);
}
bootstrap();
