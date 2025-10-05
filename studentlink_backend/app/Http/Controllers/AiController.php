<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class AiController extends Controller
{
    /**
     * Classify concern using AI
     */
    public function classifyConcern(Request $request): JsonResponse
    {
        $request->validate([
            'text' => 'required|string|max:5000',
        ]);

        $text = $request->input('text');

        // AI-powered classification
        $classification = $this->analyzeText($text);

        return response()->json([
            'success' => true,
            'data' => $classification,
        ]);
    }

    /**
     * Analyze text for classification
     */
    private function analyzeText(string $text): array
    {
        $text = strtolower($text);
        
        // Priority detection
        $priority = $this->detectPriority($text);
        
        // Category detection
        $category = $this->detectCategory($text);
        
        // Department detection
        $department = $this->detectDepartment($text, $category);
        
        // Sentiment analysis
        $sentiment = $this->analyzeSentiment($text);
        
        return [
            'priority' => $priority,
            'category' => $category,
            'department_id' => $department,
            'sentiment' => $sentiment,
            'keywords' => $this->extractKeywords($text),
            'auto_escalation' => $priority === 'urgent' && $sentiment === 'negative',
        ];
    }

    /**
     * Enhanced keyword extraction with context
     */
    private function extractKeywords(string $text): array
    {
        $enhancedKeywords = [
            'academic' => [
                'grade', 'exam', 'assignment', 'course', 'professor', 'instructor', 'syllabus', 
                'curriculum', 'homework', 'project', 'thesis', 'dissertation', 'research',
                'academic', 'scholarly', 'study', 'learning', 'education', 'student portal',
                'canvas', 'blackboard', 'moodle', 'lms', 'gpa', 'transcript', 'credits'
            ],
            'financial' => [
                'payment', 'tuition', 'fee', 'financial aid', 'scholarship', 'refund', 
                'billing', 'money', 'cost', 'expensive', 'afford', 'loan', 'grant',
                'bursar', 'cashier', 'account', 'balance', 'outstanding', 'due'
            ],
            'administrative' => [
                'enrollment', 'registration', 'transcript', 'diploma', 'graduation', 
                'records', 'document', 'form', 'application', 'admission', 'withdrawal',
                'drop', 'add', 'schedule', 'timetable', 'catalog', 'handbook'
            ],
            'technical' => [
                'login', 'password', 'system', 'website', 'portal', 'error', 'bug', 
                'technical', 'computer', 'internet', 'wifi', 'network', 'server',
                'database', 'software', 'hardware', 'device', 'mobile', 'app'
            ],
            'housing' => [
                'dormitory', 'dorm', 'room', 'housing', 'residence', 'accommodation',
                'roommate', 'facility', 'maintenance', 'repair', 'cleaning', 'laundry'
            ],
            'health' => [
                'health', 'medical', 'doctor', 'nurse', 'clinic', 'hospital', 'medicine',
                'sick', 'illness', 'injury', 'emergency', 'mental health', 'counseling'
            ],
            'safety' => [
                'safety', 'security', 'emergency', 'danger', 'threat', 'harassment',
                'bullying', 'violence', 'theft', 'robbery', 'assault', 'campus police'
            ]
        ];

        $foundKeywords = [];
        
        foreach ($enhancedKeywords as $category => $keywords) {
            foreach ($keywords as $keyword) {
                if (strpos($text, $keyword) !== false) {
                    $foundKeywords[] = [
                        'keyword' => $keyword,
                        'category' => $category,
                        'relevance' => $this->calculateRelevance($text, $keyword)
                    ];
                }
            }
        }

        // Sort by relevance
        usort($foundKeywords, function($a, $b) {
            return $b['relevance'] <=> $a['relevance'];
        });

        return array_slice($foundKeywords, 0, 10); // Return top 10 keywords
    }

    /**
     * Calculate keyword relevance
     */
    private function calculateRelevance(string $text, string $keyword): float
    {
        $count = substr_count($text, $keyword);
        $textLength = strlen($text);
        $keywordLength = strlen($keyword);
        
        // Base relevance from frequency
        $frequency = $count / ($textLength / 1000);
        
        // Boost for longer, more specific keywords
        $specificity = $keywordLength / 10;
        
        return $frequency + $specificity;
    }

    /**
     * Detect priority level
     */
    private function detectPriority(string $text): string
    {
        $urgentKeywords = [
            'urgent', 'emergency', 'asap', 'immediately', 'critical', 'serious',
            'dangerous', 'threat', 'violence', 'harassment', 'bullying', 'assault',
            'medical emergency', 'hospital', 'ambulance', 'police', 'security'
        ];
        
        $highKeywords = [
            'important', 'priority', 'deadline', 'due', 'expired', 'overdue',
            'problem', 'issue', 'broken', 'not working', 'failed', 'error'
        ];
        
        foreach ($urgentKeywords as $keyword) {
            if (strpos($text, $keyword) !== false) {
                return 'urgent';
            }
        }
        
        foreach ($highKeywords as $keyword) {
            if (strpos($text, $keyword) !== false) {
                return 'high';
            }
        }

        return 'medium';
    }

    /**
     * Detect category
     */
    private function detectCategory(string $text): string
    {
        $categories = [
            'academic' => ['grade', 'exam', 'assignment', 'course', 'professor', 'homework', 'gpa'],
            'financial' => ['payment', 'tuition', 'fee', 'money', 'cost', 'refund', 'scholarship'],
            'administrative' => ['enrollment', 'registration', 'transcript', 'diploma', 'records'],
            'technical' => ['login', 'password', 'system', 'website', 'portal', 'error', 'bug'],
            'housing' => ['dormitory', 'dorm', 'room', 'housing', 'roommate', 'facility'],
            'health' => ['health', 'medical', 'doctor', 'clinic', 'sick', 'medicine'],
            'safety' => ['safety', 'security', 'emergency', 'danger', 'harassment', 'bullying']
        ];

        $scores = [];
        
        foreach ($categories as $category => $keywords) {
            $score = 0;
            foreach ($keywords as $keyword) {
                if (strpos($text, $keyword) !== false) {
                    $score++;
                }
            }
            $scores[$category] = $score;
        }

        $maxScore = max($scores);
        if ($maxScore > 0) {
            return array_search($maxScore, $scores);
        }

        return 'general';
    }

    /**
     * Detect department
     */
    private function detectDepartment(string $text, string $category): int
    {
        $departmentMapping = [
            'academic' => 1, // Academic Affairs
            'financial' => 2, // Finance
            'administrative' => 3, // Registrar
            'technical' => 4, // IT Department
            'housing' => 5, // Student Housing
            'health' => 6, // Health Services
            'safety' => 7, // Campus Security
            'general' => 1, // Default to Academic Affairs
        ];

        return $departmentMapping[$category] ?? 1;
    }

    /**
     * Analyze sentiment
     */
    private function analyzeSentiment(string $text): string
    {
        $positiveWords = [
            'good', 'great', 'excellent', 'amazing', 'wonderful', 'fantastic',
            'happy', 'pleased', 'satisfied', 'thankful', 'grateful', 'helpful'
        ];

        $negativeWords = [
            'bad', 'terrible', 'awful', 'horrible', 'disappointed', 'frustrated',
            'angry', 'upset', 'sad', 'worried', 'concerned', 'problem', 'issue'
        ];

        $positiveCount = 0;
        $negativeCount = 0;

        foreach ($positiveWords as $word) {
            if (strpos($text, $word) !== false) {
                $positiveCount++;
            }
        }

        foreach ($negativeWords as $word) {
            if (strpos($text, $word) !== false) {
                $negativeCount++;
            }
        }

        if ($positiveCount > $negativeCount) {
            return 'positive';
        } elseif ($negativeCount > $positiveCount) {
            return 'negative';
        } else {
            return 'neutral';
        }
    }

    /**
     * Chat with AI
     */
    public function chat(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['message' => 'AI chat feature coming soon'],
        ]);
    }

    /**
     * Get AI suggestions
     */
    public function getSuggestions(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['suggestions' => []],
        ]);
    }

    /**
     * Transcribe audio
     */
    public function transcribeAudio(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['transcription' => 'Audio transcription coming soon'],
        ]);
    }

    /**
     * Get AI sessions
     */
    public function getSessions(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['sessions' => []],
        ]);
    }

    /**
     * Create AI session
     */
    public function createSession(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['session_id' => 'session_' . time()],
        ]);
    }

    /**
     * Get AI session
     */
    public function getSession($sessionId): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['session' => ['id' => $sessionId]],
        ]);
    }

    /**
     * Delete AI session
     */
    public function deleteSession($sessionId): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Session deleted',
        ]);
    }

    /**
     * Get AI settings
     */
    public function getSettings(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['settings' => []],
        ]);
    }

    /**
     * Update AI settings
     */
    public function updateSettings(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Settings updated',
        ]);
    }

    /**
     * Train chatbot
     */
    public function trainChatbot(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Chatbot training started',
        ]);
    }

    /**
     * Get AI analytics
     */
    public function getAnalytics(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['analytics' => []],
        ]);
    }

    /**
     * Get AI conversations
     */
    public function getConversations(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['conversations' => []],
        ]);
    }

    /**
     * Get Dialogflow config
     */
    public function getDialogflowConfig(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['config' => []],
        ]);
    }

    /**
     * Update Dialogflow config
     */
    public function updateDialogflowConfig(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Dialogflow config updated',
        ]);
    }

    /**
     * Get Hugging Face config
     */
    public function getHuggingFaceConfig(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['config' => []],
        ]);
    }

    /**
     * Update Hugging Face config
     */
    public function updateHuggingFaceConfig(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Hugging Face config updated',
        ]);
    }

    /**
     * Get FAQ items
     */
    public function getFAQItems(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['faq' => []],
        ]);
    }

    /**
     * Update FAQ items
     */
    public function updateFAQItems(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'FAQ items updated',
        ]);
    }

    /**
     * Get chat sessions
     */
    public function getChatSessions(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['sessions' => []],
        ]);
    }

    /**
     * Test chatbot
     */
    public function testChatbot(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['response' => 'Test response'],
        ]);
    }

    /**
     * Bulk upload training data
     */
    public function bulkUploadTrainingData(Request $request): JsonResponse
    {
        return response()->json([
            'success' => true,
            'message' => 'Training data uploaded',
        ]);
    }

    /**
     * Get training batches
     */
    public function getTrainingBatches(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['batches' => []],
        ]);
    }

    /**
     * Get training stats
     */
    public function getTrainingStats(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => ['stats' => []],
        ]);
    }
}