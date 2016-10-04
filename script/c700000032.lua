--Scripted by Eerie Code
--Thorn Observer - Zuma
function c700000032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(Card.IsSetCard,0x513))
	c:EnableReviveLimit()
	--Place Counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c700000032.pccon)
	e1:SetTarget(c700000032.pctg)
	e1:SetOperation(c700000032.pcop)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c700000032.atktg)
	c:RegisterEffect(e2)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c700000032.damtg)
	e4:SetOperation(c700000032.damop)
	c:RegisterEffect(e4)
	--No battle damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c700000032.nbcon)
	e5:SetCost(c700000032.nbcost)
	e5:SetTarget(c700000032.nbtg)
	e5:SetOperation(c700000032.nbop)
	c:RegisterEffect(e5)
end

function c700000032.pccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c700000032.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c700000032.pcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x104,1)
		tc=g:GetNext()
	end
end

function c700000032.atktg(e,c)
	return c:GetCounter(0x104)~=0
end

function c700000032.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetCounter(p,LOCATION_ONFIELD,0,0x104)
	--Debug.Message("Player: "..p.." Damage: "..ct)
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(ct*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,p,ct*400)
end
function c700000032.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	--Debug.Message("Damage: "..d)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c700000032.nbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mc=c:GetMaterialCount()
	local gc=c:GetMaterial()
	if gc:GetCount()==0 then
		--Debug.Message("No materials used.")
		return false
	end
	--Debug.Message("Material count: "..mc)
	gc=gc:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	--Debug.Message("Materials in Graveyard: "..)
	return gc:GetCount()==mc
end
function c700000032.nbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
function c700000032.nbfil(c,e,tp,mg)
	return mg:IsContains(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c700000032.nbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c700000032.nbfil,tp,LOCATION_GRAVE,0,e:GetHandler():GetMaterialCount(),nil,e,tp,e:GetHandler():GetMaterial()) end
	local g=Duel.GetMatchingGroup(c700000032.nbfil,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler():GetMaterial())
	Duel.SetTargetCard(g)
	g:KeepAlive()
	e:SetLabel(e:GetHandler():GetMaterialCount())
	e:SetLabelObject(g)
end
function c700000032.nbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c700000032.damop2)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetOperation(c700000032.spop)
	e2:SetLabel(e:GetLabel())
	e2:SetLabelObject(e:GetLabelObject())
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end
function c700000032.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c700000032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	--if c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and tc:IsLocation(LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
	--  local g=Group.FromCards(c,tc)
	--  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	--end
	if not c:IsLocation(LOCATION_GRAVE) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not tc or not tc:GetCount()==e:GetLabel() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end