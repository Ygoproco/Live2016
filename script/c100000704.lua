--ダークネス・アウトサイダー
function c100000704.initial_effect(c)
	--dishand
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
    e2:SetCost(c100000704.spcost)
	e2:SetTarget(c100000704.target)
	e2:SetOperation(c100000704.operation)
	c:RegisterEffect(e2)
end
function c100000704.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
   Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c100000704.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsPlayerCanSpecialSummon(tp) 
		and e:GetHandler():IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c100000704.filter(c,ac,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(ac) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000704.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(c100000704.filter,tp,0,LOCATION_DECK,nil,ac,e,tp)
	Duel.ConfirmCards(tp,g)
	if g:GetCount()<=0 or not c:IsRelateToEffect(e) or not c:IsAbleToDeck() then return end
	if Duel.SendtoDeck(c,1-tp,2,REASON_EFFECT)<=0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100000704.filter,tp,0,LOCATION_DECK,1,1,nil,ac,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end

