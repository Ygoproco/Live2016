--暗黒の召喚神
function c513000106.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000069,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c513000106.cost)
	e1:SetTarget(c513000106.target)
	e1:SetOperation(c513000106.operation)
	c:RegisterEffect(e1)	
end
function c513000106.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c513000106.filter(c,e,tp,code)
	return c:IsCode(code)and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c513000106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsExistingTarget(c513000106.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,6007213) 
		and Duel.IsExistingTarget(c513000106.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,32491822) 
		and Duel.IsExistingTarget(c513000106.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,69890967) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c513000106.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,6007213)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c513000106.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,32491822)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g3=Duel.SelectTarget(tp,c513000106.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,69890967)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c513000106.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()~=3 or ft<3 then return end
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
end
